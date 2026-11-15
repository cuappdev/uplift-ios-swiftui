//
//  AchievementsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AchievementsView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel
    let onShowAllBadges: () -> Void

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Achievements.sectionSpacing) {
            Button(action: onShowAllBadges) {
                sectionHeader("My Badges")
            }

            if viewModel.displayedBadges.isEmpty {
                Text("Check in at the gym to earn your first badge.")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.gray04)
            } else {
                BadgeGrid(badges: viewModel.displayedBadges, viewModel: viewModel)
            }

            nextBadgeCard
        }
    }

    @ViewBuilder
    private var nextBadgeCard: some View {
        if let badge = viewModel.nextBadge {
            HStack(spacing: Constants.Achievements.cardSpacing) {
                BadgeView(
                    badge: badge,
                    isEarned: false,
                    progress: viewModel.progress(of: badge),
                    size: Constants.Achievements.nextBadgeSize,
                    showsTitle: false
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Next up: \(badge.title)")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.black)

                    Text("\(badge.progress(in: viewModel.stats))/\(badge.goal) · \(badge.detail)")
                        .font(Constants.Fonts.labelNormal)
                        .foregroundStyle(Constants.Colors.gray04)
                }

                Spacer(minLength: 0)
            }
            .padding(Constants.Achievements.cardPadding)
            .background(Constants.Colors.lightGray)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Achievements.cardCornerRadius))
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.gray04)

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 8, height: 12)
                .foregroundStyle(Constants.Colors.gray03)
        }
    }

}
