//
//  WorkoutReminderViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/2/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import Combine

/// The ViewModel for Workout Reminder views.
@MainActor
class WorkoutReminderViewModel: ObservableObject {

    // MARK: - Properties
    @Published var reminders: [WorkoutReminder] = []

    private let notificationScheduler: NotificationScheduling = NotificationScheduler()
    private let notificationIdsKey = "workoutReminderNotificationIds"

    // MARK: - Reminder Management

    /// Adds a new workout reminder.
    func addReminder(_ reminder: WorkoutReminder) {
        reminders.append(reminder)
    }

    /// Updates an existing workout reminder with the same ID.
    func updateReminder(_ updatedReminder: WorkoutReminder) {
        guard let index = reminders.firstIndex(where: { $0.id == updatedReminder.id }) else {
            return
        }

        reminders[index] = updatedReminder
    }

    /// Deletes a workout reminder.
    func deleteReminder(_ reminder: WorkoutReminder) {
        reminders.removeAll { $0.id == reminder.id }
    }

    /// Enables or disables a workout reminder. (Unused)
    func toggleReminder(_ reminder: WorkoutReminder, isEnabled: Bool) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else {
               return
           }

           reminders[index].isEnabled = isEnabled
    }

    // MARK: - Persistence

    /// Whether the current reminders differ from the saved reminders.
    var hasUnsavedChanges: Bool {
        guard let data = UserDefaults.standard.data(forKey: "workoutReminders"),
              let savedReminders = try? JSONDecoder().decode([WorkoutReminder].self, from: data)
        else {
            return !reminders.isEmpty
        }

        return reminders != savedReminders
    }

    /// Saves workout reminders to UserDefaults and updates their scheduled notifications.
    func saveReminders() {
        do {
            let encoder = JSONEncoder()
            let remindersJson = try encoder.encode(reminders)

            UserDefaults.standard.set(remindersJson, forKey: "workoutReminders")

            cancelWorkoutReminders()
            scheduleWorkoutReminders()
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }

    /// Loads saved workout reminders from UserDefaults.
    func loadReminders() {
        let key = "workoutReminders"

        guard let data = UserDefaults.standard.data(forKey: key) else {
            reminders = []
            return
        }

        do {
            reminders = try JSONDecoder().decode([WorkoutReminder].self, from: data)
        } catch {
            print("Error decoding reminders: \(error)")
        }
    }

    // MARK: - Notifications Scheduling

    /// Schedules weekly notifications for all enabled workout reminders.
    func scheduleWorkoutReminders() {
        var scheduledIds: [String] = []

        for reminder in reminders {
            guard reminder.isEnabled,
                  let time = reminderTime(reminder) else {
                continue
            }

            for day in reminder.selectedDays {
                let id = "workoutReminder.\(reminder.id.uuidString)-\(day.rawValue)"

                notificationScheduler.scheduleWeekly(
                    id: id,
                    title: "Time to work out!",
                    body: "Don't forget your workout today!",
                    weekday: day.rawValue,
                    hour: time.hour,
                    minute: time.minute
                )

                scheduledIds.append(id)
            }
        }

        UserDefaults.standard.set(scheduledIds, forKey: notificationIdsKey)
    }

    /// Cancels all previously scheduled workout reminder notifications.
    func cancelWorkoutReminders() {
        let ids = UserDefaults.standard.stringArray(forKey: notificationIdsKey) ?? []

        for id in ids {
            notificationScheduler.cancel(id: id)
        }

        UserDefaults.standard.removeObject(forKey: notificationIdsKey)
    }

    // MARK: - Helpers

    /// Converts a workout reminder's time into 24-hour components for notification scheduling.
    /// Returns 9:00 AM for all-day reminders or nil if the time is invalid.
    func reminderTime(_ reminder: WorkoutReminder) -> (hour: Int, minute: Int)? {
        if reminder.isAllDay {
            return (9, 0)
        }

        let components = reminder.time.split(separator: " ")
        guard components.count == 2 else { return nil }

        let timeComponents = components[0].split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1]) else {
            return nil
        }

        let suffix = String(components[1])

        guard (1...12).contains(hour),
              (0...59).contains(minute),
              suffix == "AM" || suffix == "PM" else {
            return nil
        }

        let hour24 = (hour % 12) + (suffix == "PM" ? 12 : 0)

        return (hour24, minute)
    }

}

// MARK: - Workout Reminder Edit ViewModel
extension WorkoutReminderEditView {

    /// The ViewModel for creating and editing workout reminders.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

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

        /// Populates the editing fields with an existing reminder's values.
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

        /// Creates a workout reminder using the current editing fields.
        /// Preserves the provided ID and enabled state.
        func makeReminder(
            isSettingTime: Bool,
            isEnabled: Bool,
            id: UUID
        ) -> WorkoutReminder {
            let time = String(
                format: "%d:%02d %@",
                hour,
                minutes,
                timeSuffix
            )

            return WorkoutReminder(
                id: id,
                selectedDays: selectedDays,
                isAllDay: !isSettingTime,
                time: isSettingTime ? time : "9:00 AM",
                isEnabled: isEnabled
            )
        }

    }
}
