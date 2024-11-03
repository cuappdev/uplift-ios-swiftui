//
//  WorkoutReminderEditView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/2/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension WorkoutReminderEditView {

    /// The ViewModel for Workout Reminder Edit views.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var daysAWeek = 4.0
        @Published var hour: Int = 1
        @Published var minutes: Int = 0
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
