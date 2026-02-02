//
//  HomeViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI
import UpliftAPI

extension HomeView {

    /// The ViewModel for the Home page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var gyms: [Gym]?
        @Published var showCapacities: Bool = false
        @Published var showTutorial: Bool = false

        private var locationManager: LocationManager?
        private var queryBag = Set<AnyCancellable>()

        private let gymCache = GymCache.shared

        init() {
            checkShowTutorial()
        }

        /// Checks if hasSeenTutorial UserDefaults is True or False
        func checkShowTutorial() {
            let hasSeenTutorial = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.capacityTutorial)
            showTutorial = !hasSeenTutorial
        }

        /// Turns of the hasSeenTutorial UserDefaults off
        func completeTutorial() {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKeys.capacityTutorial)
            showTutorial = false
        }

        /// Toggle UserDefaults hasSeenTutorial on or off and toggles the modal on as well. Used for debugging purposes
        func toggleTutorial() {
            let current = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.capacityTutorial)
            let newValue = !current
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.capacityTutorial)
            showTutorial = !newValue
        }

        // MARK: - Requests

        /// Set up environment for this ViewModel.
        func setupEnvironment(with locationManager: LocationManager) {
            self.locationManager = locationManager
        }

        /// Fetch all gyms from the backend.
        func fetchAllGyms() {
            Task {
                do {
                    let cachedGyms = try await gymCache.fetchGyms()
                    self.gyms = sortGyms(cachedGyms)

                } catch {
                    Logger.data.critical("Error with fetching gyms: \(error)")
                    self.gyms = []
                }
            }
        }

        /// Refresh gym data from the backend.
        func refreshGyms() {
            gyms = nil
            Task {
                do {
                    // Force refresh by invalidating cache
                    await gymCache.invalidateCache()
                    let freshGyms = try await gymCache.fetchGyms()
                    self.gyms = sortGyms(freshGyms)
                } catch {
                    Logger.data.critical("Error with refreshing gyms: \(error)")
                }
            }
        }

        // MARK: - Helpers

        /**
         The heading text for the navigation bar based on the current time of day.

         * "Good Morning!" if the current hour is from 12 AM to 11AM.
         * "Good Afternoon!" if the current hour is from 12PM to 5PM.
         * "Good Evening!" if the current hour is from 6PM to 11PM.
         */
        var headingText: String {
            let hour = Calendar.current.component(.hour, from: Date.now)
            switch hour {
            case 0..<13:
                return "Good Morning!"
            case 13..<17:
                return "Good Afternoon!"
            default:
                return "Good Evening!"
            }
        }

        /// Calculates the average capacity amount of all open fitness centers.
        func calculateAverageCapacity() -> Double {
            guard let val = (gyms?.getAllFitnessCenters()
                .compactMap { facility in
                    switch facility.status {
                    case .open:
                        return facility.capacity?.percent
                    default:
                        return 0
                    }
                }
                .reduce(0, +)) else { return 0.0 }

            let openCount = gyms?.getAllFitnessCenters().filter { fc in
                switch fc.status {
                case .open:
                    return true
                default:
                    return false
                }
            }.count ?? 0

            if openCount == 0 { return 0.0 }
            return val / Double(openCount)
        }

        /// Returns the gym for a given facility or `nil` if not found.
        func gymWithFacility(_ facility: Facility?) -> Gym? {
            gyms?.first { $0.fitnessCenters.contains { $0 == facility } }
        }

        /**
        Sorts gyms by multiple criteria in priority order which is.
        
        * 1. Distance from user's location (nearest first)
        * 2. Gym status (open gyms before closed)
        * 3. Fitness center availability (gyms with open fitness centers first)
         */
        private func sortGyms(_ gyms: [Gym]) -> [Gym] {
            gyms
                .sorted {
                    guard let locationManager = self.locationManager else { return false }
                    return locationManager.distanceToCoordinates(
                        latitude: $0.latitude, longitude: $0.longitude
                    ) < locationManager.distanceToCoordinates(
                        latitude: $1.latitude, longitude: $1.longitude
                    )
                }
                .sorted {
                    guard let lhsStatus = $0.status,
                          let rhsStatus = $1.status else { return false }
                    return lhsStatus < rhsStatus
                }
                .sorted {
                    ($0.fitnessCenters.contains { fc in
                        switch fc.status {
                        case .open:
                            return true
                        default:
                            return false
                        }
                    } ? 0 : 1) < ($1.fitnessCenters.contains { fc in
                        switch fc.status {
                        case .open:
                            return true
                        default:
                            return false
                        }
                    } ? 0 : 1)
                }
        }

    }

}
