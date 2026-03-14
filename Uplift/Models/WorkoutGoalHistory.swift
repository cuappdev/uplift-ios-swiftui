//
//  WorkoutGoalHistory.swift
//  Uplift
//
//  Created by jiwon jeong on 3/5/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a workout goal history entry.
struct WorkoutGoalHistory: Hashable {

    // MARK: - Properties

    let id: ID

    let userId: Int

    let workoutGoal: Int

    let effectiveAt: DateTime

    // MARK: - Functions

    /// Initializes this object given a WorkoutgoalhistoryFields type.
    init(from history: WorkoutgoalhistoryFields) {
        self.id = history.id
        self.userId = history.userId
        self.workoutGoal = history.workoutGoal
        self.effectiveAt = history.effectiveAt
    }
}
