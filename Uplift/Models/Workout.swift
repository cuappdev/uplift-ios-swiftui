//
//  Workout.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/12/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a workout.
struct Workout: Hashable {

    // MARK: - Properties

    /// The ID of this workout.
    let id: ID

    /// The ID of the user associated with this workout.
    let userId: Int

    /// The time of this workout.
    let workoutTime: String

    let facilityId: Int

    let gymName: String

    // MARK: - Functions

    /// Initializes this object given a `UserFields` type.
    init(from workout: WorkoutFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        self.id = workout.id
        self.userId = workout.userId
        self.workoutTime = workout.workoutTime
        self.facilityId = workout.facilityId
        self.gymName = workout.gymName
    }

    init(
        id: ID,
        userId: Int,
        workoutTime: String,
        facilityId: Int,
        gymName: String
    ) {
        self.id = id
        self.userId = userId
        self.workoutTime = workoutTime
        self.facilityId = facilityId
        self.gymName = gymName
    }
}
