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

    // MARK: - Functions

    /// Initializes this object given a `UserFields` type.
    init(from workout: WorkoutFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        self.id = workout.id
        self.userId = workout.userId
        self.workoutTime = workout.workoutTime
    }

}
