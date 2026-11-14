//
//  Friendship.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

struct Friendship: Hashable, Identifiable {

    // MARK: - Properties

    let id: ID
    let acceptedAt: DateTime?
    let createdAt: DateTime?
    let friend: Friend?
    let isAccepted: Bool
    let user: Friend?

    // MARK: - Functions

    init(from friendship: FriendshipFields) {
        self.id = friendship.id
        self.acceptedAt = friendship.acceptedAt
        self.createdAt = friendship.createdAt
        self.friend = friendship.friend.map { Friend(from: $0.fragments.friendFields) }
        self.isAccepted = friendship.isAccepted ?? false
        self.user = friendship.user.map { Friend(from: $0.fragments.friendFields) }
    }

    init(
        id: ID,
        acceptedAt: DateTime?,
        createdAt: DateTime?,
        friend: Friend?,
        isAccepted: Bool,
        user: Friend?
    ) {
        self.id = id
        self.acceptedAt = acceptedAt
        self.createdAt = createdAt
        self.friend = friend
        self.isAccepted = isAccepted
        self.user = user
    }

}
