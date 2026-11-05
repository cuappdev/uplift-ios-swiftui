//
//  FriendsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FriendsView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ViewModel

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header
            content
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Constants.Colors.white)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .onAppear {
            viewModel.fetchFriends()
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Constants.Images.arrowLeftLight
                .resizable()
                .scaledToFill()
                .foregroundStyle(Constants.Colors.black)
                .frame(width: 24, height: 24)
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            Text("Friends")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.h2)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, Constants.Friends.headerBottomPadding)
        .frame(height: Constants.Friends.headerHeight)
        .background(Constants.Colors.lightGray)
    }

    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Friends.sectionSpacing) {
                friendRequestsRow

                Text("Friends")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                ForEach(viewModel.friends) { friend in
                    friendRow(friend)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.vertical, Constants.Friends.contentVerticalPadding)
        }
    }

    private var friendRequestsRow: some View {
        NavigationLink {
            AddFriendsView(viewModel: viewModel)
        } label: {
            friendRequestsLabel
        }
    }

    private var friendRequestsLabel: some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            Constants.Images.friend
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Friends.iconSize, height: Constants.Friends.iconSize)
                .foregroundStyle(Constants.Colors.black)
                .frame(width: Constants.Friends.avatarSize, height: Constants.Friends.avatarSize)
                .overlay(Circle().stroke(Constants.Colors.black, lineWidth: 1))

            VStack(alignment: .leading, spacing: Constants.Friends.labelSpacing) {
                Text("Friend requests")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.bodyMedium)

                Text("Add friends on Uplift!")
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.bodyMedium)
            }
        }
    }

    private func friendRow(_ friend: Friend) -> some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            FriendAvatar(friend: friend)

            Text(friend.name)
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.h3)
        }
    }

}

#Preview {
    NavigationStack {
        FriendsView(viewModel: FriendsView.ViewModel())
    }
}
