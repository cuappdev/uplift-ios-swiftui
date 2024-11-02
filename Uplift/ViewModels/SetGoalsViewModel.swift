//
//  SetGoalsViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension SetGoalsView {

    /// The ViewModel for the Set Goals page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var daysAWeek = 4.0
        @Published var hour: Int = 1
        @Published var minutes: Int = 0
        @Published var reminders: [WorkoutReminder] = [
            WorkoutReminder(selectedDays: [DayOfWeek.saturday, DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.sunday, DayOfWeek.saturday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday], isAllDay: true, time: "")
        ]
        @Published var selectedDays: [DayOfWeek] = []
        @Published var timeSuffix: String = "AM"

        // MARK: - Helpers

        /// Sets the `selectedDays` to include every day of the week if `isEveryDay` is true, otherwise it is set to be
        /// empty.
        func setEveryDay(_ isEveryDay: Bool) {
            selectedDays = isEveryDay ? DayOfWeek.sortedDaysOfWeek() : []
        }

    }
}
