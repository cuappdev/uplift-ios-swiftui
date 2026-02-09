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

        @Published var daysAWeek = 4.0
        @Published var reminders: [WorkoutReminder] = [
            WorkoutReminder(selectedDays: [DayOfWeek.saturday, DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.sunday, DayOfWeek.saturday], isAllDay: true, time: ""),
            WorkoutReminder(selectedDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday], isAllDay: true, time: "")
        ]

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Requests

        /// Sets the user's workout goal.
        func setWorkoutGoal(
            userId: Int,
            workoutGoal: Int,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            Network.client.mutationPublisher(
                // TODO: Format of workout goal is incorrect right now
                mutation: SetWorkoutGoalsMutation(userId: userId, workoutGoal: ["Monday"])
            )
            .sink { [weak self] completion in
                guard let self else { return }

                if case let .failure(error) = completion {
                    Logger.data.critical("Error in SetGoalsViewModel.setWorkoutGoal: \(error)")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
#if DEBUG
                Logger.data.log("NetID \(userId) has set goal to \(workoutGoal)")
#endif
                completion(.success(()))
            }
            .store(in: &queryBag)
        }

    }
}
