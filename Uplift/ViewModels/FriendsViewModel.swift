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

        enum RequestStatus {
            case available
            case friends
            case incoming
            case requested
            case yourself
        }

        enum SearchState {
            case failed
            case found(Friend)
            case idle
            case loading
            case notFound
        }

        // MARK: - Properties

        @Published private(set) var friends: [Friend] = []
        @Published private(set) var requests: [Friendship] = []
        @Published private(set) var updates: [Friendship] = []
        @Published private(set) var searchState: SearchState = .idle
        @Published var searchText = "" {
            didSet {
                if searchText != oldValue {
                    searchCancellable?.cancel()
                    searchState = .idle
                }
            }
        }

        @Published private var busyIds = Set<Friend.ID>()
        @Published private var pendingIds = Set<Friend.ID>()
        private var fetchCancellable: AnyCancellable?
        private var queryBag = Set<AnyCancellable>()
        private var searchCancellable: AnyCancellable?
        private var userId: Int?

        // MARK: - Requests

        func fetchFriends() {
            guard let netId = UserSessionManager.shared.netID else { return }

            fetchCancellable = Network.client.queryPublisher(
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

                load(
                    friends: friends.map(Friend.init),
                    sent: sent.map(Friendship.init),
                    received: received.map(Friendship.init),
                    userId: Int(user.id)
                )
            }
        }

        func search() {
            let netId = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard !netId.isEmpty else { return }

            searchState = .loading
            searchCancellable = Network.client.queryPublisher(
                query: SearchUserByNetIdQuery(netId: .some(netId)),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .map { $0.data?.getUserByNetId?.compactMap { $0 }.first }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    Logger.data.error("Error in FriendsViewModel.search: \(error)")
                    // The backend reports an unknown netid as a GraphQL error
                    self?.searchState = error is GraphQLErrorWrapper ? .notFound : .failed
                }
            } receiveValue: { [weak self] user in
                self?.searchState = user.map { .found(Friend(from: $0.fragments.friendFields)) } ?? .notFound
            }
        }

        func sendRequest(to friend: Friend) {
            guard let userId, let friendId = Int(friend.id), !isBusy(friend) else { return }

            busyIds.insert(friend.id)
            Network.client.mutationPublisher(
                mutation: AddFriendMutation(friendId: friendId, userId: userId)
            )
            .sink { [weak self] completion in
                self?.busyIds.remove(friend.id)
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.sendRequest: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self, result.data?.addFriend != nil else { return }

                pendingIds.insert(friend.id)
                fetchFriends()
            }
            .store(in: &queryBag)
        }

        func acceptRequest(from friend: Friend) {
            guard let request = requests.first(where: { $0.user?.id == friend.id }) else { return }
            accept(request)
        }

        func accept(_ request: Friendship) {
            guard let friendshipId = Int(request.id),
                  let sender = request.user, !isBusy(sender) else { return }

            busyIds.insert(sender.id)
            Network.client.mutationPublisher(
                mutation: AcceptFriendRequestMutation(friendshipId: friendshipId)
            )
            .sink { [weak self] completion in
                self?.busyIds.remove(sender.id)
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.accept: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self, result.data?.acceptFriendRequest != nil else { return }

                requests.removeAll { $0.id == request.id }
                friends = sortedByName(friends + [sender])
                fetchFriends()
            }
            .store(in: &queryBag)
        }

        func decline(_ request: Friendship) {
            guard let userId, let sender = request.user,
                  let senderId = Int(sender.id), !isBusy(sender) else { return }

            busyIds.insert(sender.id)
            Network.client.mutationPublisher(
                mutation: RemoveFriendMutation(friendId: senderId, userId: userId)
            )
            .sink { [weak self] completion in
                self?.busyIds.remove(sender.id)
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FriendsViewModel.decline: \(error)")
                }
            } receiveValue: { [weak self] result in
                guard let self, result.data?.removeFriend?.success == true else { return }

                requests.removeAll { $0.id == request.id }
                fetchFriends()
            }
            .store(in: &queryBag)
        }

        // MARK: - Helpers

        func load(friends: [Friend], sent: [Friendship], received: [Friendship], userId: Int? = nil) {
            self.userId = userId
            self.friends = sortedByName(friends)
            pendingIds = Set(sent.filter { !$0.isAccepted }.compactMap { $0.friend?.id })
            requests = received
                .filter { !$0.isAccepted }
                .sorted { ($0.createdAt ?? "") > ($1.createdAt ?? "") }
            updates = sent
                .filter(\.isAccepted)
                .sorted { ($0.acceptedAt ?? "") > ($1.acceptedAt ?? "") }
        }

        func status(of friend: Friend) -> RequestStatus {
            if friend.id == userId.map(String.init) {
                return .yourself
            } else if friends.contains(where: { $0.id == friend.id }) {
                return .friends
            } else if requests.contains(where: { $0.user?.id == friend.id }) {
                return .incoming
            } else if pendingIds.contains(friend.id) {
                return .requested
            }
            return .available
        }

        func isBusy(_ friend: Friend) -> Bool {
            busyIds.contains(friend.id)
        }

        func clearSearch() {
            searchText = ""
        }

        func timeAgo(_ dateTime: DateTime?) -> String {
            dateTime.flatMap(Foundation.Date.fromBackend)?.timeAgo ?? ""
        }

        private func sortedByName(_ friends: [Friend]) -> [Friend] {
            friends.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

    }

}
