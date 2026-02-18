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
        @Published var reminders: [WorkoutReminder] = [
            WorkoutReminder(selectedDays: [DayOfWeek.saturday, DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.sunday, DayOfWeek.saturday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday], isAllDay: true, time: "")
        ]

    }
}
