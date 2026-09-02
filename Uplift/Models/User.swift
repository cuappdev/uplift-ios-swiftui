//
//  User.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/25/24.
//  Modified by Jiwon Jeong on 3/5/26.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a user.
struct User: Hashable {

    // MARK: - Properties

    /// The ID of this user.
    let id: ID
    /// The email of this user.
    let email: String?
    /// The name of this user.
    let name: String
    /// The net ID of this user.
    let netId: String
    /// The weekly workout goal of this user.
    let workoutGoal: Int?
    /// The current active streak of this user.
    let activeStreak: Int
    /// The maximum streak of this user.
    let maxStreak: Int
    /// The date/value of the last streak.
    let lastStreak: Int
    /// The last time user changed workout goal.
    let lastGoalChange: DateTime?
    /// The encoded profile image of this user.
    let encodedImage: String?
    /// The history of workout goals for this user.
    let goalHistory: [WorkoutGoalHistory?]?
    /// The total number of gym days for this user.
    let totalGymDays: Int
    /// The start date of the current streak.
    let streakStart: DateTime?
    /// Workout History for this user.
    let workoutHistory: [Workout]

    // MARK: - Functions

    /// Initializes this object given a UserFields type.
    init(from user: UserFields) {
        self.id = user.id
        self.email = user.email
        self.name = user.name
        self.netId = user.netId
        self.activeStreak = user.activeStreak
        self.maxStreak = user.maxStreak
        self.workoutGoal = user.workoutGoal
        self.encodedImage = user.encodedImage
        self.lastStreak = user.lastStreak
        self.lastGoalChange = user.lastGoalChange
        self.goalHistory = user.goalHistory?.map { $0.map { WorkoutGoalHistory(from: $0.fragments.workoutGoalHistoryFields) } }
        self.totalGymDays = user.totalGymDays
        self.streakStart = user.streakStart
        self.workoutHistory = user.workoutHistory?.compactMap { $0.map { Workout(from: $0.fragments.workoutFields) } } ?? []
    }

    init(
        id: ID,
        email: String?,
        name: String,
        netId: String,
        workoutGoal: Int?,
        activeStreak: Int,
        maxStreak: Int,
        lastStreak: Int,
        lastGoalChange: DateTime,
        encodedImage: String?,
        goalHistory: [WorkoutGoalHistory?]?,
        totalGymDays: Int,
        streakStart: DateTime?,
        workoutHistory: [Workout]
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.netId = netId
        self.workoutGoal = workoutGoal
        self.activeStreak = activeStreak
        self.maxStreak = maxStreak
        self.lastStreak = lastStreak
        self.lastGoalChange = lastGoalChange
        self.encodedImage = encodedImage
        self.goalHistory = goalHistory
        self.totalGymDays = totalGymDays
        self.streakStart = streakStart
        self.workoutHistory = workoutHistory
    }
}
