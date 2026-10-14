//
//  SetGoalsViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI
import UpliftAPI
import OSLog

extension SetGoalsView {

    /// The ViewModel for the Set Goals page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var showWarningModal = false
        @Published var showErrorModal = false
        @Published var sliderWorkoutGoal = 1.0
        @Published var reminders: [WorkoutReminder] = []
        var currWorkoutGoal = 1

        private var queryBag = Set<AnyCancellable>()

        var hasUnsavedChanges: Bool {
            !isWorkoutGoal || haveRemindersChanged
        }

        private let notificationScheduler: NotificationScheduling = NotificationScheduler()
        private let notificationIdsKey = "workoutReminderNotificationIds"

        // MARK: - Helpers

        /// Whether the workout goal slider is the same as the existing workout goal.
        var isWorkoutGoal: Bool {
            Int(sliderWorkoutGoal) == currWorkoutGoal
        }

        /// Determines whether the last workout goal change was within 30 days ago.
        /// Last goal change is in this format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS". Change if this is no longer true.
        /// e.g. 2026-03-18T20:27:31.084971
        func isGoalChangeLocked(lastGoalChange: DateTime?) -> Bool {
            guard let unlockDate = unlockDate(lastGoalChange: lastGoalChange) else {
                return false
            }
            return unlockDate > Foundation.Date.now
        }

        /// Return the date that goal changing is next allowed.
        /// Last goal change is in this format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS". Change if this is no longer true.
        /// e.g. 2026-03-18T20:27:31.084971
        func unlockDate(lastGoalChange: DateTime?) -> Foundation.Date? {
            guard let lastGoalChange else { return nil }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .gmt
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            guard let lastChangeDate = formatter.date(from: lastGoalChange) else {
                Logger.data.error("Could not parse lastGoalChange (check formatter): \(lastGoalChange)")
                return nil
            }

            guard let unlockDate = Calendar.current.date(byAdding: .day, value: 30, to: lastChangeDate) else {
                return nil
            }

            return unlockDate
        }

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

        func cancelWorkoutReminders() {
            let ids = UserDefaults.standard.stringArray(forKey: notificationIdsKey) ?? []

            for id in ids {
                notificationScheduler.cancel(id: id)
            }

            UserDefaults.standard.removeObject(forKey: notificationIdsKey)
        }

        // MARK: - Requests

        /// Sets the user's workout goal.
        func setWorkoutGoal(
            userId: Int,
            workoutGoal: Int,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            Network.client.mutationPublisher(
                mutation: SetWorkoutGoalsMutation(userId: userId, workoutGoal: workoutGoal)
            )
            .sink { response in
                if case let .failure(error) = response {
                    Logger.data.critical("Error in SetGoalsViewModel.setWorkoutGoal: \(error)")
                    completion(.failure(error))
                }
            } receiveValue: { _ in
#if DEBUG
                Logger.data.log("User id \(userId) has set goal to \(workoutGoal)")
#endif
                completion(.success(()))
            }
            .store(in: &queryBag)
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
            guard let data = UserDefaults.standard.data(forKey: "workoutReminders") else {
                reminders = []
                return
            }

            do {
                reminders = try JSONDecoder().decode([WorkoutReminder].self, from: data)
            } catch {
                print("Error decoding reminders: \(error)")
            }
        }

        var haveRemindersChanged: Bool {
            guard let data = UserDefaults.standard.data(forKey: "workoutReminders"),
                  let savedReminders = try? JSONDecoder().decode([WorkoutReminder].self, from: data)
            else {
                return !reminders.isEmpty
            }

            return reminders != savedReminders
        }

        func scheduleWorkoutReminders() {
            var scheduledIds: [String] = []

            for (index, reminder) in reminders.enumerated() {
                guard let time = reminderTime(reminder) else {
                    continue
                }

                for day in reminder.selectedDays {
                    let id = "workoutReminder.\(index)-\(day.rawValue)"

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
    }
}
