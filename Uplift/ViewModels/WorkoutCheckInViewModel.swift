//
//  WorkoutCheckInViewModel.swift
//  Uplift
//
//  Created by Duru Alayli on 11/14/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI
import CoreLocation

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
        private var locationManager: LocationManaging?
        private var queryBag = Set<AnyCancellable>()

        var gyms: [Gym] = []
        var visibility: ((Bool) -> Void)?

        init(locationManager: LocationManaging = LocationManager.shared) {
            self.locationManager = locationManager
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

            guard let locationManager = locationManager, locationManager.userLocation != nil else {
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
            let lastDate = UserDefaults.standard.object(forKey: cooldownKey) as? Date
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
            let lastDate = UserDefaults.standard.object(forKey: dailyCooldownKey) as? Date

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
            UserDefaults.standard.set(Date(), forKey: cooldownKey)
            UserDefaults.standard.set(gym, forKey: cooldownLastGymKey)
            isCooldownActive = true
        }

        /// Start daily cooldown for checking in to a gym
        func startDailyCooldown() {
            UserDefaults.standard.set(Calendar.current.startOfDay(for: Date()), forKey: dailyCooldownKey)
            isDailyCooldownActive = true
        }

        /// Update the profile workout checkin database and history
        func performCheckIn(gymName: String?, profileViewModel: ProfileView.ViewModel) {
            // TODO: Adjust the profile database update logic (streaks, badges, workout history etc.)
            profileViewModel.totalWorkouts += 1
            profileViewModel.weeklyWorkouts.currentWeekWorkouts += 1
            profileViewModel.streaks += 1
            if let gym = gymName {
                let workout = WorkoutHistory(
                    id: "workout\(profileViewModel.weeklyWorkouts.currentWeekWorkouts)",
                    location: gym,
                    time: Date().timeStringTrailingZeros,
                    date: Date().dateStringDayMonth
                )
                profileViewModel.workoutHistory.insert(workout, at: 0)
            }
        }
    }
}
