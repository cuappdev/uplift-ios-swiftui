//
//  User.swift
//  Uplift
//
//  Created by Belle Hu on 4/13/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI

/// Model representing a user.
struct User: Hashable {

    // MARK: - Properties

    /// The unique identifier of this user.
    let id: Int!

    /// The unique netId of this user.
    let netId: String!

    /// The list of giveaways this user is in.
    let giveaways: [Giveaway]?

    struct GiveawayTrunc: Equatable, Hashable {
        let id: String
        let name: String
    }

    init(from user: UserFields) {
        self.id = user.id
        self.netId = user.netId
        self.giveaways = [Giveaway](user.giveaways?.compactMap {
            return GiveawayTrunc(id: $0.id, name: $0.name)
        } ?? [])
    }
}
