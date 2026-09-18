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

/// notifies the user when they arrive at a gym
final class GymProximityManager: ObservableObject {
    // MARK: - Properties

    static let shared = GymProximityManager()

    @Published private(set) var isEnabled = true

    /// radius of each gym's region
    private let regionRadius: CLLocationDistance = 100

    /// how long the user must stay inside a region before the notification fires.
    private let dwellTime: TimeInterval = 5 * 60

    private let notificationIdPrefix = "gymProximity."

    /// min time between notifications for the same gym
    private let cooldown: TimeInterval = 4 * 60 * 60

    /// gyms saved to disk at refresh, read on background wake
    private var snapshots: [String: GymSnapshot] = [:]

    private let defaults: UserDefaults
    private let now: () -> Date

    private let locationManager: LocationManaging
    private let scheduler: NotificationScheduling
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        locationManager: LocationManaging = LocationManager.shared,
        scheduler: NotificationScheduling = NotificationScheduler(),
        defaults: UserDefaults = .standard,
        now: @escaping () -> Date = Date.init
    ) {
        self.locationManager = locationManager
        self.scheduler = scheduler
        self.defaults = defaults
        self.now = now
        snapshots = loadSnapshots()

        locationManager.regionEnteredPublisher
            .sink { [weak self] gymId in
                self?.handleEntered(gymId: gymId)
            }
            .store(in: &cancellables)

        locationManager.regionExitedPublisher
            .sink { [weak self] gymId in
                self?.handleExited(gymId: gymId)
            }
            .store(in: &cancellables)

        locationManager.authorizationStatusPublisher
            .sink { [weak self] status in
                guard status == .authorizedAlways else { return }
                Task { await self?.refreshRegions() }
            }
            .store(in: &cancellables)
    }

    // MARK: - Functions

    /// fetch gyms, save snapshots & register one geofence per gym
    func refreshRegions() async {
        guard isEnabled else { return }

        do {
            let gyms = try await GymCache.shared.fetchGyms()
            saveSnapshots(gyms.map { GymSnapshot(from: $0) })
        } catch {
            Logger.services.error("Could not fetch gyms, using saved snapshots: \(error)")
        }

        let regions = snapshots.values.map { gym in
            let region = CLCircularRegion(
                center: CLLocationCoordinate2D(latitude: gym.latitude, longitude: gym.longitude),
                radius: regionRadius,
                identifier: gym.id
            )
            region.notifyOnEntry = true
            region.notifyOnExit = true
            return region
        }

        Logger.services.info("Registering \(regions.count) gym regions")
        locationManager.startMonitoring(regions: regions)
    }

    private func handleEntered(gymId: String) {
        guard isEnabled, let gym = snapshots[gymId] else {
            return
        }

        guard !hasCheckedInToday(), !notifiedRecently(gymId: gymId) else {
            return
        }

        guard gym.hoursAreStale(at: now()) || gym.isFitnessCenterOpen(at: now()) else {
            return
        }

        Logger.services.info("Arming proximity notification for \(gym.name)")

        scheduler.schedule(
            id: notificationIdPrefix + gymId,
            title: "You're near \(gym.name)",
            body: "Ready to get a workout in?",
            delay: dwellTime
        )
        recordNotified(gymId: gymId)
    }

    private func handleExited(gymId: String) {
        Logger.services.info("Cancelling proximity notification for \(gymId)")
        scheduler.cancel(id: notificationIdPrefix + gymId)
    }

    private func hasCheckedInToday() -> Bool {
        guard let last = defaults.object(forKey: Constants.UserDefaultsKeys.checkInLastDate) as? Date else { return false }
        return Calendar.current.isDate(last, inSameDayAs: now())
    }

    private func notifiedRecently(gymId: String) -> Bool {
        let all = defaults.dictionary(forKey: Constants.UserDefaultsKeys.proximityLastNotified) as? [String: Double] ?? [:]
        guard let last = all[gymId] else { return false }
        return now().timeIntervalSince1970 - last < cooldown
    }

    private func recordNotified(gymId: String) {
        var all = defaults.dictionary(forKey: Constants.UserDefaultsKeys.proximityLastNotified) as? [String: Double] ?? [:]
        all[gymId] = now().timeIntervalSince1970
        defaults.set(all, forKey: Constants.UserDefaultsKeys.proximityLastNotified)
    }

    private func loadSnapshots() -> [String: GymSnapshot] {
        guard let data = defaults.data(forKey: Constants.UserDefaultsKeys.proximityGymSnapshots),
              let gyms = try? JSONDecoder().decode([GymSnapshot].self, from: data) else { return [:] }
        return Dictionary(uniqueKeysWithValues: gyms.map { ($0.id, $0) })
    }

    private func saveSnapshots(_ gyms: [GymSnapshot]) {
        guard let data = try? JSONEncoder().encode(gyms) else { return }
        defaults.set(data, forKey: Constants.UserDefaultsKeys.proximityGymSnapshots)
        snapshots = Dictionary(uniqueKeysWithValues: gyms.map { ($0.id, $0) })
    }

}
