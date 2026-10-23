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

    func addReminder(_ reminder: WorkoutReminder) {
        reminders.append(reminder)
    }

    func updateReminder(_ updatedReminder: WorkoutReminder) {
        guard let index = reminders.firstIndex(where: { $0.id == updatedReminder.id }) else {
            return
        }

        reminders[index] = updatedReminder
    }

    func deleteReminder(_ reminder: WorkoutReminder) {
        reminders.removeAll { $0.id == reminder.id }
    }

    func toggleReminder(_ reminder: WorkoutReminder, isEnabled: Bool) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else {
               return
           }

           reminders[index].isEnabled = isEnabled
    }

    // MARK: - Persistence

    var haveRemindersChanged: Bool {
        guard let data = UserDefaults.standard.data(forKey: "workoutReminders"),
              let savedReminders = try? JSONDecoder().decode([WorkoutReminder].self, from: data)
        else {
            return !reminders.isEmpty
        }

        return reminders != savedReminders
    }

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

    func loadReminders() {
        let key = "workoutReminders"

        guard let data = UserDefaults.standard.data(forKey: key) else {
            reminders = []
            return
        }

        do {
            reminders = try JSONDecoder().decode([WorkoutReminder].self, from: data)

            // Persist generated UUIDs for older reminders.
            if let savedJSON = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
               savedJSON.contains(where: { $0["id"] == nil }) {
                let updatedData = try JSONEncoder().encode(reminders)
                UserDefaults.standard.set(updatedData, forKey: key)
            }
        } catch {
            print("Error decoding reminders: \(error)")
        }
    }

    // MARK: - Notifications Scheduling

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

    func cancelWorkoutReminders() {
        let ids = UserDefaults.standard.stringArray(forKey: notificationIdsKey) ?? []

        for id in ids {
            notificationScheduler.cancel(id: id)
        }

        UserDefaults.standard.removeObject(forKey: notificationIdsKey)
    }

    // MARK: - Helpers

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
