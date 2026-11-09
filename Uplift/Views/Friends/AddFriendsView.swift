//
//  AddFriendsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/5/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AddFriendsView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: FriendsView.ViewModel
    @FocusState private var isSearchFocused: Bool

    // MARK: - UI

    var body: some View {
        content
            .pushedScreen(title: "Add Friends")
            .onAppear {
                viewModel.fetchFriends()
            }
            .onDisappear {
                viewModel.clearSearch()
            }
    }

    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Friends.sectionSpacing) {
                searchBar

                searchContent
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.vertical, Constants.Friends.contentVerticalPadding)
        }
    }

    private var searchBar: some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            searchField

            if isSearchFocused || !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                    isSearchFocused = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f3)
                }
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Constants.Colors.gray04)

            TextField(
                "",
                text: $viewModel.searchText,
                prompt: Text("Search for friends using netid")
                    .foregroundColor(Constants.Colors.gray04)
                    .font(Constants.Fonts.f3)
            )
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.f3)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.search)
            .focused($isSearchFocused)
            .onSubmit {
                viewModel.search()
            }
        }
        .padding(Constants.Friends.searchPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.Friends.searchCornerRadius)
                .foregroundStyle(Constants.Colors.gray01)
        )
    }

    @ViewBuilder
    private var searchContent: some View {
        switch viewModel.searchState {
        case .found(let friend):
            searchResultRow(friend)
        case .failed:
            emptyLabel("Something went wrong. Please try again.")
        case .idle:
            requestsSection

            updatesSection
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .notFound:
            notFoundView
        }
    }

    private var notFoundView: some View {
        VStack(spacing: Constants.Friends.rowSpacing) {
            Text("No users found")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.h3)

            Text("\(viewModel.searchText) isn't on Uplift yet. Invite them to join!")
                .foregroundStyle(Constants.Colors.gray04)
                .font(Constants.Fonts.bodyMedium)
                .multilineTextAlignment(.center)

            ShareLink(item: Constants.Friends.inviteMessage) {
                actionLabel(
                    "Invite",
                    background: Constants.Colors.yellow,
                    icon: Image(systemName: "square.and.arrow.up")
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Constants.Friends.sectionSpacing)
    }

    private var requestsSection: some View {
        VStack(alignment: .leading, spacing: Constants.Friends.sectionSpacing) {
            sectionTitle("Requests")

            if viewModel.requests.isEmpty {
                emptyLabel("No friend requests yet")
            }

            ForEach(viewModel.requests) { request in
                requestRow(request)
            }
        }
    }

    private var updatesSection: some View {
        VStack(alignment: .leading, spacing: Constants.Friends.sectionSpacing) {
            sectionTitle("Updates")

            if viewModel.updates.isEmpty {
                emptyLabel("No updates yet")
            }

            ForEach(viewModel.updates) { update in
                updateRow(update)
            }
        }
    }

    // MARK: - Supporting

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.h2)
    }

    private func emptyLabel(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(Constants.Colors.gray04)
            .font(Constants.Fonts.bodyMedium)
    }

    @ViewBuilder
    private func requestRow(_ request: Friendship) -> some View {
        if let sender = request.user {
            HStack(spacing: Constants.Friends.rowSpacing) {
                FriendAvatar(friend: sender)

                Text(sender.name)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
                    .lineLimit(1)

                Spacer()

                Button {
                    viewModel.accept(request)
                } label: {
                    actionLabel("Accept", background: Constants.Colors.yellow)
                }

                Button {
                    viewModel.decline(request)
                } label: {
                    actionLabel("Decline", background: Constants.Colors.gray01)
                }
            }
            .disabled(viewModel.isBusy(sender))
        }
    }

    private func searchResultRow(_ friend: Friend) -> some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            FriendAvatar(friend: friend)

            VStack(alignment: .leading, spacing: Constants.Friends.labelSpacing) {
                Text(friend.name)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
                    .lineLimit(1)

                Text(friend.netId)
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.labelMedium)
            }

            Spacer()

            requestButton(for: friend)
        }
    }

    @ViewBuilder
    private func requestButton(for friend: Friend) -> some View {
        switch viewModel.status(of: friend) {
        case .available:
            Button {
                viewModel.sendRequest(to: friend)
            } label: {
                actionLabel("Request", background: Constants.Colors.yellow)
            }
            .disabled(viewModel.isBusy(friend))
        case .friends:
            actionLabel("Friends", background: Constants.Colors.gray01)
        case .incoming:
            Button {
                viewModel.acceptRequest(from: friend)
            } label: {
                actionLabel("Accept", background: Constants.Colors.yellow)
            }
            .disabled(viewModel.isBusy(friend))
        case .requested:
            actionLabel("Requested", background: Constants.Colors.gray01, icon: Image(systemName: "checkmark"))
        case .yourself:
            EmptyView()
        }
    }

    private func actionLabel(_ title: String, background: Color, icon: Image? = nil) -> some View {
        HStack(spacing: Constants.Friends.labelSpacing) {
            icon

            Text(title)
        }
        .foregroundStyle(Constants.Colors.black)
        .font(Constants.Fonts.labelSemibold)
        .padding(.horizontal, Constants.Friends.buttonHorizontalPadding)
        .padding(.vertical, Constants.Friends.buttonVerticalPadding)
        .background(Capsule().fill(background))
    }

    @ViewBuilder
    private func updateRow(_ update: Friendship) -> some View {
        if let friend = update.friend {
            HStack(spacing: Constants.Friends.rowSpacing) {
                FriendAvatar(friend: friend)

                Text("\(friend.name) accepted your invite.")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.bodyMedium)

                Spacer()

                Text(viewModel.timeAgo(update.acceptedAt))
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.labelMedium)
            }
        }
    }

}

#Preview {
    NavigationStack {
        AddFriendsView(viewModel: FriendsView.ViewModel())
    }
}
