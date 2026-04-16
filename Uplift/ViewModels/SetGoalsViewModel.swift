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
        @Published var reminders: [WorkoutReminder] = [
            WorkoutReminder(selectedDays: [DayOfWeek.saturday, DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.sunday, DayOfWeek.saturday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday], isAllDay: true, time: "")
        ]
        var currWorkoutGoal = 1

        private var queryBag = Set<AnyCancellable>()

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
            return unlockDate > Date.now
        }

        /// Return the date that goal changing is next allowed.
        /// Last goal change is in this format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS". Change if this is no longer true.
        /// e.g. 2026-03-18T20:27:31.084971
        func unlockDate(lastGoalChange: DateTime?) -> Date? {
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

    }
}
