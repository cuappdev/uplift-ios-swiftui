//
//  FitnessCenterViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension FitnessCenterView {

    /// The ViewModel for the Fitness Center view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var currentHour: Int = Calendar.current.component(.hour, from: Date())
        @Published var daysOfWeek: [String] = []
        @Published var expandHours: Bool = false
        @Published var fitnessCenterHours: [String] = []

        // MARK: - Helpers

        /// Fetch a sorted array of strings for fitness center hours.
        func fetchFitnessCenterHours(for fc: Facility) {
            fitnessCenterHours = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                let hours = fc.hours.getHoursInDayOfWeek(dayOfWeek: day).sorted()

                if hours.isEmpty {
                    fitnessCenterHours.append("Closed")
                } else if hours.count > 1 {
                    fitnessCenterHours.append(hours.map { $0.formatOpenCloseHours() }.joined(separator: "\n"))
                } else {
                    fitnessCenterHours.append(hours.first?.formatOpenCloseHours() ?? "")
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
                    daysOfWeek.append(day.dayOfWeekShortened())
                }
            }
        }
    }

}
