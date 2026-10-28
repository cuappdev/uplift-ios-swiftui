//
//  WeeklyProgress.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/28/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct WeeklyProgress: Equatable {

    // MARK: - Properties

    let goal: Int
    let gymDays: [Workout]

    // MARK: - Init

    init(workouts: [Workout], goal: Int?, now: Date = .now) {
        let thisWeek = now.startOfWeek...now
        var seenDays = Set<Date>()

        self.goal = min(max(goal ?? 1, 1), Constants.Streaks.maxGoal)
        self.gymDays = workouts
            .compactMap { workout in workout.date.map { (workout: workout, date: $0) } }
            .filter { thisWeek.contains($0.date) }
            .sorted { $0.date < $1.date }
            .filter { seenDays.insert(Calendar.current.startOfDay(for: $0.date)).inserted }
            .map(\.workout)
    }

    // MARK: - Computed Properties

    var completedCount: Int {
        min(gymDays.count, goal)
    }

    var remainingCount: Int {
        goal - completedCount
    }

    var fraction: Double {
        Double(completedCount) / Double(goal)
    }

    var isComplete: Bool {
        remainingCount == 0
    }

    // MARK: - Helpers

    func hasGymDay(on day: Date) -> Bool {
        gymDays.compactMap(\.date).contains { Calendar.current.isDate($0, inSameDayAs: day) }
    }

}
