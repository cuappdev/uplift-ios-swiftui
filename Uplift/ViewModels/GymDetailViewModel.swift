//
//  GymDetailViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import Foundation

extension GymDetailView {

    /// The ViewModel for the Gym detailed view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var buildingHours: [String] = []
        @Published var daysOfWeek: [String] = []
        @Published var showHours: Bool = false

        // MARK: - Helpers

        /// Fetch a sorted array of strings for building hours.
        func fetchBuildingHours(for gym: Gym) {
            buildingHours = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                let hours = gym.hours.getHoursInDayOfWeek(dayOfWeek: day)

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
        func fetchDaysOfWeek(for gym: Gym) {
            daysOfWeek = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                if day == Date.now.getDayOfWeek() {
                    daysOfWeek.append("Today")
                } else {
                    daysOfWeek.append(day.dayOfWeekAbbreviation())
                }
            }
        }

    }

}
