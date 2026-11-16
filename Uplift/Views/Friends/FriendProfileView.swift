//
//  FriendProfileView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FriendProfileView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel

    init(friend: Friend) {
        _viewModel = StateObject(wrappedValue: ViewModel(friend: friend))
    }

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.FriendProfile.sectionSpacing) {
                header

                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                case .hidden:
                    privateNotice
                case .loaded(let profile):
                    stats(profile)
                    badges(profile)
                }
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.vertical, Constants.Friends.contentVerticalPadding)
        }
        .pushedScreen(title: viewModel.friend.name)
        .onAppear(perform: viewModel.fetch)
    }

    private var header: some View {
        HStack(spacing: Constants.FriendProfile.headerSpacing) {
            FriendAvatar(friend: viewModel.friend, size: Constants.FriendProfile.avatarSize)

            VStack(alignment: .leading, spacing: Constants.Friends.labelSpacing) {
                Text(viewModel.friend.name)
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)

                Text(viewModel.friend.netId)
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.gray04)
            }
        }
    }

    private var privateNotice: some View {
        HStack(spacing: Constants.Achievements.cardSpacing) {
            Image(systemName: "lock.fill")
                .foregroundStyle(Constants.Colors.gray03)

            Text("\(viewModel.friend.name)'s stats are private for now.")
                .font(Constants.Fonts.bodyNormal)
                .foregroundStyle(Constants.Colors.gray04)
        }
        .padding(Constants.Achievements.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Constants.Colors.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Achievements.cardCornerRadius))
    }

    private func stats(_ profile: FriendProfile) -> some View {
        HStack(spacing: Constants.Profile.statSpacing) {
            stat("\(profile.gymDays)", label: "Gym Days")
            stat("\(profile.activeStreak)", label: "Streak")
            stat(viewModel.weekText(of: profile), label: "This Week")
            stat("\(profile.friendCount)", label: "Friends")
        }
    }

    private func stat(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            Text(label)
                .font(Constants.Fonts.labelMedium)
                .foregroundStyle(Constants.Colors.gray04)
        }
    }

    private func badges(_ profile: FriendProfile) -> some View {
        VStack(alignment: .leading, spacing: Constants.Achievements.sectionSpacing) {
            Text("Badges (\(profile.badgeStats.earnedBadges.count)/\(Badge.all.count))")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.gray04)

            let showcase = viewModel.showcase(of: profile)
            if showcase.isEmpty {
                Text("No badges yet.")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.gray04)
            } else {
                BadgeGrid(badges: showcase, stats: profile.badgeStats)
            }
        }
    }

}
