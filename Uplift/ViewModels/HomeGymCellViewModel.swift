//
//  HomeGymCellViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/24/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension HomeGymCell {

    /// The ViewModel for a Gym Cell on the main view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Helpers

        /// Determine whether at least one fitness center is open at this `Gym`.
        func fitnessCenterIsOpen(gym: Gym) -> Bool {
            gym.fitnessCenters.allSatisfy {
                switch $0.status {
                case .closed:
                    return false
                default:
                    return true
                }
            }
        }

        /// Determine the close time of the latest closing fitness center that is currently open at this `Gym`.
        func determineCloseTime(gym: Gym) -> Date? {
            var possibleCloseTimes: [Date] = []

            gym.fitnessCenters.forEach {
                switch $0.status {
                case .open(let closeTime):
                    possibleCloseTimes.append(closeTime)
                default:
                    break
                }
            }

            return possibleCloseTimes.sorted(by: {
                switch $0.compare($1) {
                case .orderedDescending:
                    return true
                default:
                    return false
                }
            }).first
        }

        /// Determine the open time of the earliest opening fitness center of this `Gym`.
        func determineOpenTime(gym: Gym) -> Date? {
            var possibleOpenTimes: [Date] = []

            gym.fitnessCenters.forEach {
                switch $0.status {
                case .closed(let openTime):
                    possibleOpenTimes.append(openTime)
                default:
                    break
                }
            }

            return possibleOpenTimes.sorted(by: {
                switch $0.compare($1) {
                case .orderedAscending:
                    return true
                default:
                    return false
                }
            }).first
        }

    }

}
