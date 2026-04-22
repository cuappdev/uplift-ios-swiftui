//
//  WorkoutCheckInViewModel.swift
//  Uplift
//
//  Created by Duru Alayli on 11/14/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI
import UpliftAPI
import CoreLocation
import OSLog

extension WorkoutCheckInView {

    /// The ViewModel for the workout checkin view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var nearestGymText: String = "Finding gyms nearby..."
        @Published var isCooldownActive: Bool = false
        @Published var isDailyCooldownActive: Bool = false
        @Published var currentNearestGym: String?

        @Published var isCheckedIn = false
        @Published var trigger: Int = 0

        private let threshold: Double = 0.05
        private let cooldownDuration: TimeInterval = 2*60*60
        private let cooldownLastGymKey = "lastCooldownGym"
        private let cooldownKey = "lastCooldownTime"
        private let dailyCooldownKey = "lastCheckInDate"
        private let locationManager: LocationManaging
        private var queryBag = Set<AnyCancellable>()

        var gyms: [Gym] = []
        var visibility: ((Bool) -> Void)?

        init(locationManager: LocationManaging = LocationManager.shared) {
            self.locationManager = locationManager

            locationManager.userLocationPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.findNearestGym()
                }
                .store(in: &queryBag)
        }

        // MARK: - Helpers

        /// Update gyms to get sorted version and call function to find a gym close enough
        func updateGyms(_ gyms: [Gym]) {
            self.gyms = gyms
            findNearestGym()
        }

        /// Sort through gyms to find if a gym is close enough
        func findNearestGym() {
            if isDailyCooldownActive {
                visibility?(false)
                return
            }

            if isCooldownActive {
                visibility?(false)
                return
            }

            guard locationManager.userLocation != nil else {
                nearestGymText = "Finding gyms nearby..."
                visibility?(false)
                return
            }

            guard !gyms.isEmpty else {
                nearestGymText = "Finding gyms nearby..."
                visibility?(false)
                return
            }

            let gymsByDistance = gyms.sorted { g1, g2 in
                let d1 = Double(locationManager.distanceToCoordinatesTwo(
                    latitude: g1.latitude,
                    longitude: g1.longitude
                )) ?? .infinity
                let d2 = Double(locationManager.distanceToCoordinatesTwo(
                    latitude: g2.latitude,
                    longitude: g2.longitude
                )) ?? .infinity
                return d1 < d2
            }

            for gym in gymsByDistance {
                let distanceString = locationManager.distanceToCoordinatesTwo(
                    latitude: gym.latitude,
                    longitude: gym.longitude
                )

                guard let distanceNumeric = Double(distanceString) else {
                    continue
                }

                if distanceNumeric <= threshold, case .open = gym.status {
                    let time = Date().timeStringTrailingZeros
                    let gymName = gym.name
                    currentNearestGym = gym.name
                    checkCooldown(gym: gymName)
                    if isCooldownActive {
                        visibility?(false)
                        return
                    }
                    nearestGymText = "\(gymName) at \(time)"
                    visibility?(true)
                    return
                }
            }

            nearestGymText = "Finding gyms nearby..."
            visibility?(false)
        }

        /// Check if the view is in 2 hour cooldown for pressing the close button
        func checkCooldown(gym: String) {
            let lastDate = UserDefaults.standard.object(forKey: cooldownKey) as? Foundation.Date
            let lastGym = UserDefaults.standard.string(forKey: cooldownLastGymKey)

            if lastGym != gym {
                isCooldownActive = false
                return
            }

            if let lastDate {
                let passed = Date().timeIntervalSince(lastDate)
                if passed < cooldownDuration {
                    isCooldownActive = true
                } else {
                    isCooldownActive = false
                }
            } else {
                isCooldownActive = false
            }
        }

        /// Check if the view is in daily cooldown for already checking in to a gym
        func checkDailyCooldown() {
            let lastDate = UserDefaults.standard.object(forKey: dailyCooldownKey) as? Foundation.Date

            if let lastDate {
                let today = Calendar.current.startOfDay(for: Date())
                if Calendar.current.isDate(lastDate, inSameDayAs: today) {
                    isDailyCooldownActive = true
                } else {
                    isDailyCooldownActive = false
                }
            } else {
                isDailyCooldownActive = false
            }
        }

        /// Start 2 hour cooldown for pressing close button
        func startCooldown(gym: String) {
            UserDefaults.standard.set(Foundation.Date(), forKey: cooldownKey)
            UserDefaults.standard.set(gym, forKey: cooldownLastGymKey)
            isCooldownActive = true
        }

        /// Start daily cooldown for checking in to a gym
        func startDailyCooldown() {
            UserDefaults.standard.set(Calendar.current.startOfDay(for: Date()), forKey: dailyCooldownKey)
            isDailyCooldownActive = true
        }

        /// Update the profile workout checkin database and history
        func handleCheckIn(user: User?) async {
            guard let user,
                  let userId = Int(user.id) else { return }

            guard let gymName = currentNearestGym,
                  let gym = gyms.first(where: { $0.name == gymName }),
                  let facility = gym.facilities.first,
                  let facilityId = Int(facility.id) else { return }

            await withCheckedContinuation { continuation in
                var cancellable: AnyCancellable?
                cancellable = Network.client.mutationPublisher(
                    mutation: LogWorkoutMutation(
                        facilityId: facilityId,
                        userId: userId,
                        workoutTime: ISO8601DateFormatter().string(from: Date())
                    )
                )
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("Error in WorkoutCheckInViewModel: \(error)")
                        self?.isCheckedIn = false
                    }
                    continuation.resume()
                    _ = cancellable
                } receiveValue: { [weak self] _ in
                    Logger.data.info("Successfully logged workout")
                    self?.isCheckedIn = true
                }
            }
        }
    }
}
