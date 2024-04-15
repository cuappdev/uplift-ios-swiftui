//
//  Giveaway.swift
//  Uplift
//
//  Created by Belle Hu on 4/13/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI

/// Model representing a giveaway.
struct Giveaway: Hashable {

    // MARK: - Properties

    /// The unique identifier of this giveaway.
    let id: String!

    /// The list of users in this giveaway.
    let users: [User]?

    /// The name of this giveaway.
    let name: String!

    /// Initializes this object given a `GiveawayFields` type.
    init(from giveaway: GiveawayFields) {
        self.id = giveaway.id
        self.name = giveaway.name
        self.users = [User](giveaway.users?.compactMap(\.?.fragments.userFields) ?? [])
    }

}
