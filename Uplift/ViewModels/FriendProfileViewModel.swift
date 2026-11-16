//
//  FriendProfileViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import OSLog
import UpliftAPI

extension FriendProfileView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Types

        enum State: Equatable {
            case hidden
            case loaded(FriendProfile)
            case loading
        }

        // MARK: - Properties

        @Published private(set) var state = State.loading

        let friend: Friend
        private var fetchCancellable: AnyCancellable?

        init(friend: Friend) {
            self.friend = friend
        }

        // MARK: - Requests

        func fetch() {
            fetchCancellable = Network.client.queryPublisher(
                query: GetFriendProfileQuery(netId: .some(friend.netId)),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    Logger.data.error("Error in FriendProfileViewModel.fetch: \(error)")
                    self?.state = .hidden
                }
            } receiveValue: { [weak self] result in
                guard let user = result.data?.getUserByNetId?.compactMap({ $0 }).first else {
                    self?.state = .hidden
                    return
                }
                self?.state = .loaded(FriendProfile(from: user))
            }
        }

        // MARK: - Helpers

        func showcase(of profile: FriendProfile) -> [Badge] {
            Badge.showcase(of: profile.badgeStats.earnedBadges)
        }

        func weekText(of profile: FriendProfile) -> String {
            guard let goal = profile.workoutGoal else { return "\(profile.daysThisWeek())" }
            return "\(profile.daysThisWeek())/\(goal)"
        }

    }

}
