//
//  User.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/25/24.
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

    /// The workout goal of this user.
    let workoutGoal: [DayOfWeekGraphQLEnum]

    // MARK: - Functions

    /// Initializes this object given a `UserFields` type.
    init(from user: UserFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        self.id = user.id
        self.email = user.email
        self.name = user.name
        self.netId = user.netId
        self.workoutGoal = user.workoutGoal?.compactMap(\.?.value) ?? []
    }

}
