//
//  FriendAvatar.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Kingfisher
import SwiftUI

struct FriendAvatar: View {

    // MARK: - Properties

    let friend: Friend
    var size = Constants.Friends.avatarSize

    // MARK: - UI

    var body: some View {
        Group {
            if let imageURL = friend.imageURL {
                KFImage(imageURL)
                    .placeholder { placeholder }
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Circle()
            .fill(Constants.Colors.gray02)
    }

}

#Preview {
    FriendAvatar(friend: Friend(id: "1", encodedImage: nil, name: "Angela Chiang", netId: "ac123"))
}
