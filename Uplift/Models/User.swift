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
    let id: String!

    /// The list of giveaways this user is in.
    let giveaways: [GiveawayTrunc]?

    /// The unique netId of this user.
    let netId: String!

    /// Truncated Giveaway object without users field.
    struct GiveawayTrunc: Equatable, Hashable {
        let id: String
        let name: String
    }

    /// Initializes this object given a `UserFields` type.
    init(from user: UserFields) {
        self.id = user.id
        self.netId = user.netId
        self.giveaways = [GiveawayTrunc](user.giveaways?.compactMap {
            if let id = $0?.id, let name = $0?.name {
                return GiveawayTrunc(id: id, name: name)
            } else {
                return nil
            }
        } ?? [])
    }

}
