//
//  GymProximityManager.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/17/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import OSLog

/// Notifies the user when they arrive at a gym.
@MainActor
final class GymProximityManager: ObservableObject {

    // MARK: - Properties

    static let shared = GymProximityManager()

    @Published private(set) var isEnabled: Bool

    /// Radius of each gym's region. iOS gets unreliable under ~100 m.
    private let regionRadius: CLLocationDistance = 100

    private let rules = GymProximityRules()

    /// Gyms saved to disk at refresh, read on background wake.
    private var snapshots: [String: GymSnapshot] = [:]

    private let defaults: UserDefaults
    private let now: () -> Date
    private let fetchGyms: () async throws -> [Gym]

    private let locationManager: LocationManaging
    private let scheduler: NotificationScheduling
    private var cancellables = Set<AnyCancellable>()

    private var lastArmedTimes: [String: Double] {
        get { defaults.dictionary(forKey: Constants.UserDefaultsKeys.proximityLastArmed) as? [String: Double] ?? [:] }
        set { defaults.set(newValue, forKey: Constants.UserDefaultsKeys.proximityLastArmed) }
    }

    // MARK: - Init

    init(
        locationManager: LocationManaging = LocationManager.shared,
        scheduler: NotificationScheduling = NotificationScheduler(),
        defaults: UserDefaults = .standard,
        now: @escaping () -> Date = Date.init,
        fetchGyms: @escaping () async throws -> [Gym] = { try await GymCache.shared.fetchGyms() }
    ) {
        self.locationManager = locationManager
        self.scheduler = scheduler
        self.defaults = defaults
        self.now = now
        self.fetchGyms = fetchGyms
        isEnabled = defaults.bool(forKey: Constants.UserDefaultsKeys.proximityRemindersEnabled)
        snapshots = loadSnapshots()

        locationManager.regionEnteredPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gymId in
                self?.handleEntered(gymId: gymId)
            }
            .store(in: &cancellables)

        locationManager.regionExitedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gymId in
                self?.handleExited(gymId: gymId)
            }
            .store(in: &cancellables)

        locationManager.authorizationStatusPublisher
            .removeDuplicates()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                if status == .authorizedAlways {
                    Task { await self.refreshRegions() }
                } else {
                    self.locationManager.stopMonitoringAllRegions()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Functions

    /// Fetch gyms, save snapshots, and register one geofence per gym.
    func refreshRegions() async {
        guard isEnabled else { return }

        do {
            let gyms = try await fetchGyms()
            saveSnapshots(gyms.map { GymSnapshot(from: $0) })
        } catch {
            Logger.services.error("Could not fetch gyms, using saved snapshots: \(error)")
        }

        guard isEnabled, locationManager.authorizationStatus == .authorizedAlways else { return }

        let regions = snapshots.values.map(region(for:))
        Logger.services.info("Registering \(regions.count) gym regions")
        locationManager.startMonitoring(regions: regions)
    }

    /// Turn the feature on and register regions once permission allows.
    func enable() async {
        setEnabled(true)
        locationManager.requestAlwaysAuthorization()
        await refreshRegions()
    }

    /// Turn the feature off, cancel pending banners, and stop monitoring.
    func disable() {
        setEnabled(false)
        for gymId in snapshots.keys {
            scheduler.cancel(id: Constants.NotificationIds.proximityPrefix + gymId)
        }
        locationManager.stopMonitoringAllRegions()
    }

    /// Arm a banner for this gym unless the rules say otherwise.
    func handleEntered(gymId: String) {
        guard isEnabled, let gym = snapshots[gymId] else { return }

        let decision = rules.decision(
            for: gym,
            lastArmed: lastArmed(gymId: gymId),
            checkedInToday: hasCheckedInToday(),
            now: now()
        )

        switch decision {
        case .arm:
            Logger.services.info("Arming proximity notification for \(gym.name)")
            scheduler.schedule(
                id: Constants.NotificationIds.proximityPrefix + gymId,
                title: "You're near \(gym.name)",
                body: "Ready to get a workout in? 💪",
                delay: rules.dwell
            )
            lastArmedTimes[gymId] = now().timeIntervalSince1970
        case .skip(let reason):
            Logger.services.info("Skipping proximity notification for \(gym.name): \(String(describing: reason))")
        }
    }

    /// Cancel the pending banner, and forget the arm if it never fired.
    func handleExited(gymId: String) {
        Logger.services.info("Cancelling proximity notification for \(gymId)")
        scheduler.cancel(id: Constants.NotificationIds.proximityPrefix + gymId)

        if let armedAt = lastArmed(gymId: gymId), rules.bannerIsPending(armedAt: armedAt, now: now()) {
            lastArmedTimes[gymId] = nil
        }
    }

    private func region(for gym: GymSnapshot) -> CLCircularRegion {
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: gym.latitude, longitude: gym.longitude),
            radius: regionRadius,
            identifier: gym.id
        )
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }

    private func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        defaults.set(enabled, forKey: Constants.UserDefaultsKeys.proximityRemindersEnabled)
    }

    private func hasCheckedInToday() -> Bool {
        let last = defaults.object(forKey: Constants.UserDefaultsKeys.checkInLastDate) as? Date
        guard let last else { return false }
        return Calendar.current.isDate(last, inSameDayAs: now())
    }

    private func lastArmed(gymId: String) -> Date? {
        lastArmedTimes[gymId].map { Date(timeIntervalSince1970: $0) }
    }

    private func loadSnapshots() -> [String: GymSnapshot] {
        guard let data = defaults.data(forKey: Constants.UserDefaultsKeys.proximityGymSnapshots),
              let gyms = try? JSONDecoder().decode([GymSnapshot].self, from: data) else { return [:] }
        return indexed(gyms)
    }

    private func saveSnapshots(_ gyms: [GymSnapshot]) {
        guard let data = try? JSONEncoder().encode(gyms) else { return }
        defaults.set(data, forKey: Constants.UserDefaultsKeys.proximityGymSnapshots)
        snapshots = indexed(gyms)
    }

    private func indexed(_ gyms: [GymSnapshot]) -> [String: GymSnapshot] {
        Dictionary(gyms.map { ($0.id, $0) }, uniquingKeysWith: { _, latest in latest })
    }

}
