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

    private var gymNames: [String: String] = [:]

    private let locationManager: LocationManaging
    private let scheduler: NotificationScheduling
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        locationManager: LocationManaging = LocationManager.shared,
        scheduler: NotificationScheduling = NotificationScheduler()
    ) {
        self.locationManager = locationManager
        self.scheduler = scheduler

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

    /// fetch the gyms & register one geofence per each of the gyms
    func refreshRegions() async {
        guard isEnabled else { return }

        do {
            let gyms = try await GymCache.shared.fetchGyms()
            gymNames = Dictionary(uniqueKeysWithValues: gyms.map { ($0.id, $0.name) })

            let regions = gyms.map { gym in
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
        } catch {
            Logger.services.error("Could not fetch gyms for proximity regions: \(error)")
        }
    }

    private func handleEntered(gymId: String) {
        guard isEnabled else { return }

        let name = gymNames[gymId] ?? "a gym"
        Logger.services.info("Arming proximity notification for \(name)")

        scheduler.schedule(
            id: notificationIdPrefix + gymId,
            title: "You're near \(name)",
            body: "Ready to get a workout in?",
            delay: dwellTime
        )
    }

    private func handleExited(gymId: String) {
        Logger.services.info("Cancelling proximity notification for \(gymId)")
        scheduler.cancel(id: notificationIdPrefix + gymId)
    }

}
