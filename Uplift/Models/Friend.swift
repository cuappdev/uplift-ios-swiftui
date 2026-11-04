//
//  Friend.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

struct Friend: Hashable, Identifiable {

    // MARK: - Properties

    let id: ID
    let encodedImage: String?
    let name: String
    let netId: String

    // MARK: - Functions

    init(from friend: FriendFields) {
        self.id = friend.id
        self.encodedImage = friend.encodedImage
        self.name = friend.name
        self.netId = friend.netId
    }

    init(
        id: ID,
        encodedImage: String?,
        name: String,
        netId: String
    ) {
        self.id = id
        self.encodedImage = encodedImage
        self.name = name
        self.netId = netId
    }

}
