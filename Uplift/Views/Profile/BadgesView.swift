//
//  BadgesView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BadgesView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AchievementsView.ViewModel

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Achievements.pageSpacing) {
                Text("All Badges (\(viewModel.earnedBadges.count)/\(Badge.all.count))")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)

                if !viewModel.displayedBadges.isEmpty {
                    section(
                        title: "Displayed on Profile",
                        count: "\(viewModel.displayedBadges.count)/\(Constants.Badges.displayedCount)",
                        badges: viewModel.displayedBadges
                    )
                }

                ForEach(Badge.Category.allCases, id: \.self) { category in
                    section(
                        title: category.rawValue,
                        count: "\(viewModel.earnedCount(in: category))/\(viewModel.badges(in: category).count)",
                        badges: viewModel.badges(in: category)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.vertical, Constants.Friends.contentVerticalPadding)
        }
        .pushedScreen(title: "My Badges")
    }

    private func section(title: String, count: String, badges: [Badge]) -> some View {
        VStack(alignment: .leading, spacing: Constants.Achievements.sectionSpacing) {
            Text("\(title) (\(count))")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            BadgeGrid(badges: badges, viewModel: viewModel)
        }
    }

}
