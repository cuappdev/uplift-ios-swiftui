//
//  FriendsTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

@MainActor
struct FriendsTests {

    private func makeFriend(_ name: String) -> Friend {
        Friend(id: name, encodedImage: nil, name: name, netId: name)
    }

    private func makeFriendship(
        id: String,
        isAccepted: Bool,
        createdAt: String? = nil,
        acceptedAt: String? = nil
    ) -> Friendship {
        Friendship(
            id: id,
            acceptedAt: acceptedAt,
            createdAt: createdAt,
            friend: makeFriend("Me"),
            isAccepted: isAccepted,
            user: makeFriend("Sender \(id)")
        )
    }

    @Test("friends are sorted by name")
    func sortsFriends() {
        let viewModel = FriendsView.ViewModel()

        viewModel.load(
            friends: [makeFriend("caitlyn"), makeFriend("Angela"), makeFriend("Rohan")],
            sent: [],
            received: []
        )

        #expect(viewModel.friends.map(\.name) == ["Angela", "caitlyn", "Rohan"])
    }

    @Test("requests only show pending received invites, newest first")
    func filtersRequests() {
        let viewModel = FriendsView.ViewModel()

        viewModel.load(
            friends: [],
            sent: [makeFriendship(id: "1", isAccepted: false, createdAt: "2026-11-04T12:00:00")],
            received: [
                makeFriendship(id: "2", isAccepted: false, createdAt: "2026-11-01T12:00:00"),
                makeFriendship(id: "3", isAccepted: true, createdAt: "2026-11-02T12:00:00"),
                makeFriendship(id: "4", isAccepted: false, createdAt: "2026-11-03T12:00:00")
            ]
        )

        #expect(viewModel.requests.map(\.id) == ["4", "2"])
    }

    @Test("updates only show accepted sent invites, newest first")
    func filtersUpdates() {
        let viewModel = FriendsView.ViewModel()

        viewModel.load(
            friends: [],
            sent: [
                makeFriendship(id: "1", isAccepted: true, acceptedAt: "2026-11-01T12:00:00"),
                makeFriendship(id: "2", isAccepted: false),
                makeFriendship(id: "3", isAccepted: true, acceptedAt: "2026-11-03T12:00:00")
            ],
            received: [makeFriendship(id: "4", isAccepted: true, acceptedAt: "2026-11-04T12:00:00")]
        )

        #expect(viewModel.updates.map(\.id) == ["3", "1"])
    }

    @Test("time ago handles timestamps with and without a timezone")
    func formatsTimeAgo() {
        let viewModel = FriendsView.ViewModel()

        #expect(viewModel.timeAgo(nil).isEmpty)
        #expect(viewModel.timeAgo("not a date").isEmpty)
        #expect(!viewModel.timeAgo("2026-11-03T12:00:00+00:00").isEmpty)
        #expect(!viewModel.timeAgo("2026-11-03T12:00:00.123456").isEmpty)
    }

    @Test("backend dates without a timezone are read as UTC")
    func parsesBackendDates() {
        let withZone = Date.fromBackend("2026-11-03T12:00:00+00:00")

        #expect(withZone != nil)
        #expect(Date.fromBackend("2026-11-03T12:00:00.123456") == withZone)
        #expect(Date.fromBackend("not a date") == nil)
    }

    @Test("friend image url only accepts web links")
    func imageURL() {
        let photo = Friend(id: "1", encodedImage: "https://example.com/a.png", name: "A", netId: "a1")
        let encoded = Friend(id: "2", encodedImage: "iVBORw0KGgo", name: "B", netId: "b1")

        #expect(photo.imageURL?.absoluteString == "https://example.com/a.png")
        #expect(encoded.imageURL == nil)
        #expect(makeFriend("C").imageURL == nil)
    }

    @Test("search results show the right request status")
    func requestStatus() {
        let viewModel = FriendsView.ViewModel()
        let pending = Friendship(
            id: "1",
            acceptedAt: nil,
            createdAt: nil,
            friend: makeFriend("Rohan"),
            isAccepted: false,
            user: makeFriend("Me")
        )

        viewModel.load(
            friends: [makeFriend("Angela")],
            sent: [pending],
            received: [makeFriendship(id: "2", isAccepted: false)],
            userId: 7
        )

        #expect(viewModel.status(of: makeFriend("Angela")) == .friends)
        #expect(viewModel.status(of: makeFriend("Sender 2")) == .incoming)
        #expect(viewModel.status(of: makeFriend("Rohan")) == .requested)
        #expect(viewModel.status(of: makeFriend("Caitlyn")) == .available)
        #expect(viewModel.status(of: Friend(id: "7", encodedImage: nil, name: "Me", netId: "me1")) == .yourself)
    }

}
