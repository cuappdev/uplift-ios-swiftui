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

        func loadReminder(_ reminder: WorkoutReminder) {
            selectedDays = reminder.selectedDays

            if !reminder.isAllDay {
                let components = reminder.time.split(separator: " ")
                guard components.count == 2 else { return }

                let timeComponents = components[0].split(separator: ":")
                guard timeComponents.count == 2,
                      let hour = Int(timeComponents[0]),
                      let minutes = Int(timeComponents[1])
                else {
                    return
                }

                self.hour = hour
                self.minutes = minutes
                timeSuffix = String(components[1])
            }
        }

        func makeReminder(isSettingTime: Bool, isEnabled: Bool) -> WorkoutReminder {
            let time = String(
                format: "%d:%02d %@",
                hour,
                minutes,
                timeSuffix
            )

            return WorkoutReminder(
                selectedDays: selectedDays,
                isAllDay: !isSettingTime,
                time: isSettingTime ? time : "9:00 AM",
                isEnabled: isEnabled
            )
        }

    }
}
