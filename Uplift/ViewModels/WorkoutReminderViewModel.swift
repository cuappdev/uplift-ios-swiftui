//
//  WorkoutReminderViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/2/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension WorkoutReminderView {

    /// The ViewModel for Workout Reminder views.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        // MARK: - Helpers

        /// Converts the given `days` to a sorted string of abbreviated days.
        func daysToString(_ days: [DayOfWeek]) -> String {
            if days.count == 7 {
                return "Every Day"
            } else if days.count == 1 {
                return days.first?.dayOfWeekComplete() ?? ""
            } else if days.contains(DayOfWeek.saturday) && days.contains(DayOfWeek.sunday) {
                return "Weekends"
            } else if !days.contains(DayOfWeek.saturday) && !days.contains(DayOfWeek.sunday) && days.count == 5 {
                return "Weekdays"
            }
            return days.map { $0.dayOfWeekAbbreviation() }.sorted().joined(separator: " ")
        }

        /// Converts the given `time` to a string.
        func timeToString(_ time: String) -> String {
            // TODO: Fix after figuring out time object in backend
            "3:00 PM"
        }

    }
}
