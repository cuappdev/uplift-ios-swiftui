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
        @Published var selectedDays: [DayOfWeek] = []
        @Published var reminders: [WorkoutReminder] = [WorkoutReminder(selectedDays: [], isAllDay: true, time: "")]
        @Published var timeSuffix: String = "AM"

        // MARK: - Helpers

        func setEveryDay(_ isEveryDay: Bool) {
            selectedDays = isEveryDay ? DayOfWeek.sortedDaysOfWeek() : []
        }

    }
}
