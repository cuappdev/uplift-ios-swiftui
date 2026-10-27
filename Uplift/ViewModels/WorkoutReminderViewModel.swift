//
//  WorkoutReminderViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/2/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import Combine
import OSLog

/// The ViewModel for Workout Reminder views.
@MainActor
class WorkoutReminderViewModel: ObservableObject {

    // MARK: - Properties
    @Published var reminders: [WorkoutReminder] = []

    private let notificationScheduler: NotificationScheduling

    init(notificationScheduler: NotificationScheduling = NotificationScheduler()) {
        self.notificationScheduler = notificationScheduler
    }

    // MARK: - Reminder Management

    /// Adds a new workout reminder.
    func addReminder(_ reminder: WorkoutReminder) {
        reminders.append(reminder)
        saveReminders()
        scheduleWorkoutReminder(reminder)
    }

    /// Updates an existing workout reminder with the same ID.
    func updateReminder(_ updatedReminder: WorkoutReminder) {
        guard let index = reminders.firstIndex(where: { $0.id == updatedReminder.id }) else {
            return
        }

        let oldReminder = reminders[index]
        reminders[index] = updatedReminder
        saveReminders()
        cancelWorkoutReminder(oldReminder)
        scheduleWorkoutReminder(updatedReminder)
    }

    /// Deletes a workout reminder.
    func deleteReminder(_ reminder: WorkoutReminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveReminders()
        cancelWorkoutReminder(reminder)
    }

    /// Enables or disables a workout reminder. (Unused)
    func toggleReminder(_ reminder: WorkoutReminder, isEnabled: Bool) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else {
               return
           }

        reminders[index].isEnabled = isEnabled
        saveReminders()
        cancelWorkoutReminder(reminder)
        scheduleWorkoutReminder(reminders[index])

    }

    // MARK: - Persistence

    /// Saves workout reminders to UserDefaults.
    private func saveReminders() {
        do {
            let encoder = JSONEncoder()
            let remindersJson = try encoder.encode(reminders)

            UserDefaults.standard.set(remindersJson, forKey: Constants.UserDefaultsKeys.workoutReminders)

        } catch {
            Logger.data.error("Error encoding JSON: \(error)")
        }
    }

    /// Loads saved workout reminders from UserDefaults.
    func loadReminders() {
        guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.workoutReminders) else {
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

    /// Schedules weekly notifications for one enabled workout reminder.
    private func scheduleWorkoutReminder(_ reminder: WorkoutReminder) {
        guard reminder.isEnabled,
              let time = reminderTime(reminder) else {
            return
        }

        var scheduledIds = UserDefaults.standard.stringArray(
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        ) ?? []

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

            if !scheduledIds.contains(id) {
                scheduledIds.append(id)
            }
        }

        UserDefaults.standard.set(
            scheduledIds,
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        )
    }

    /// Cancels a workout reminder's notifications and removes their stored IDs.
    private func cancelWorkoutReminder(_ reminder: WorkoutReminder) {
        let idsToCancel = Set(
            reminder.selectedDays.map { day in
                "workoutReminder.\(reminder.id.uuidString)-\(day.rawValue)"
            }
        )

        for id in idsToCancel {
            notificationScheduler.cancel(id: id)
        }

        let scheduledIds = UserDefaults.standard.stringArray(
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        ) ?? []

        let remainingIds = scheduledIds.filter { !idsToCancel.contains($0) }

        UserDefaults.standard.set(
            remainingIds,
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        )
    }

    /// Clears all previously scheduled workout reminder notifications.
    func clearWorkoutReminders() {
        let ids = UserDefaults.standard.stringArray(
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        ) ?? []

        for id in ids {
            notificationScheduler.cancel(id: id)
        }

        UserDefaults.standard.removeObject(
            forKey: Constants.UserDefaultsKeys.workoutReminders
        )
        UserDefaults.standard.removeObject(
            forKey: Constants.UserDefaultsKeys.workoutReminderNotificationIds
        )

        reminders = []
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
