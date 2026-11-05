//
//  FriendsViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import OSLog
import UpliftAPI

extension FriendsView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published private(set) var friends: [Friend] = []
        @Published private(set) var requests: [Friendship] = []
        @Published private(set) var updates: [Friendship] = []
        @Published var searchText = ""

        private var queryBag = Set<AnyCancellable>()
        private var userId: Int?

        // MARK: - Requests

        func fetchFriends() {
            guard let netId = UserSessionManager.shared.netID else { return }

            Network.client.queryPublisher(
                query: GetFriendsQuery(netId: .some(netId)),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .compactMap { $0.data?.getUserByNetId?.compactMap { $0 }.first }
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.fetchFriends: \(error)")
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }

                let friends = user.friends?.compactMap { $0?.fragments.friendFields } ?? []
                let sent = user.friendRequestsSent?.compactMap { $0?.fragments.friendshipFields } ?? []
                let received = user.friendRequestsReceived?.compactMap { $0?.fragments.friendshipFields } ?? []

                userId = Int(user.id)
                load(
                    friends: friends.map(Friend.init),
                    sent: sent.map(Friendship.init),
                    received: received.map(Friendship.init)
                )
            }
            .store(in: &queryBag)
        }

        func accept(_ request: Friendship) {
            guard let friendshipId = Int(request.id) else { return }

            Network.client.mutationPublisher(
                mutation: AcceptFriendRequestMutation(friendshipId: friendshipId)
            )
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.accept: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self, result.data?.acceptFriendRequest != nil else { return }

                requests.removeAll { $0.id == request.id }
                if let sender = request.user {
                    friends = sortedByName(friends + [sender])
                }
            }
            .store(in: &queryBag)
        }

        func decline(_ request: Friendship) {
            guard let userId,
                  let senderId = request.user.flatMap({ Int($0.id) }) else { return }

            Network.client.mutationPublisher(
                mutation: RemoveFriendMutation(friendId: senderId, userId: userId)
            )
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.decline: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self, result.data?.removeFriend?.success == true else { return }

                requests.removeAll { $0.id == request.id }
            }
            .store(in: &queryBag)
        }

        // MARK: - Helpers

        func load(friends: [Friend], sent: [Friendship], received: [Friendship]) {
            self.friends = sortedByName(friends)
            requests = received
                .filter { !$0.isAccepted }
                .sorted { ($0.createdAt ?? "") > ($1.createdAt ?? "") }
            updates = sent
                .filter(\.isAccepted)
                .sorted { ($0.acceptedAt ?? "") > ($1.acceptedAt ?? "") }
        }

        func timeAgo(_ dateTime: DateTime?) -> String {
            guard let dateTime, let date = date(from: dateTime) else { return "" }
            return date.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated))
        }

        private func date(from dateTime: DateTime) -> Foundation.Date? {
            if let date = WorkoutTimeFormatter.isoToDate(dateTime) {
                return date
            }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return formatter.date(from: String(dateTime.prefix(19)))
        }

        private func sortedByName(_ friends: [Friend]) -> [Friend] {
            friends.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

    }

}
