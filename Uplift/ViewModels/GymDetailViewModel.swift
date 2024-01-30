//
//  GymDetailViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension GymDetailView {

    /// The ViewModel for the Gym detailed view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var buildingHours: [String] = []
        @Published var daysOfWeek: [String] = []
        @Published var selectedTab: GymTabType?
        @Published var showHours: Bool = false

        /// An enumeration representing different gyms used for sliding tab bar purposes.
        enum GymName {
            case morrison
            case teagle
            case other
        }

        // MARK: - Helpers

        /// Determine selected tab.
        func determineSelectedTab(gym: Gym) {
            if gym.facilityWithName(name: Constants.FacilityNames.teagleDown) != nil {
                selectedTab = .teagleDown
            } else {
                selectedTab = .fitnessCenter
            }
        }

        /// Fetch a sorted array of strings for building hours.
        func fetchBuildingHours(for gym: Gym) {
            buildingHours = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                let hours = gym.hours.getHoursInDayOfWeek(dayOfWeek: day).sorted()

                if hours.isEmpty {
                    buildingHours.append("Closed")
                } else if hours.count > 1 {
                    buildingHours.append(hours.map { $0.formatOpenCloseHours() }.joined(separator: "\n"))
                } else {
                    buildingHours.append(hours.first?.formatOpenCloseHours() ?? "")
                }
            }
        }

        /// Fetch a sorted array of strings for days of the week.
        func fetchDaysOfWeek() {
            daysOfWeek = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                if day == Date.now.getDayOfWeek() {
                    daysOfWeek.append("Today")
                } else {
                    daysOfWeek.append(day.dayOfWeekAbbreviation())
                }
            }
        }

        /// Determine the gym name enumeration value given a `Gym` object.
        func determineGymNameEnum(gym: Gym) -> GymName {
            if gym.facilityWithName(name: Constants.FacilityNames.teagleDown) != nil {
                return .teagle
            } else if gym.facilityWithName(name: Constants.FacilityNames.morrFitness) != nil {
                return .morrison
            } else {
                return .other
            }
        }

    }

}
