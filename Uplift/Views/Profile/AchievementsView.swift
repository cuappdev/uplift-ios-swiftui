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
    @ObservedObject var recordsViewModel: PersonalRecordsView.ViewModel
    let onShowAllBadges: () -> Void
    let onSelectBadge: (Badge) -> Void
    let onShowRecords: () -> Void

    @State private var editorLift = ""
    @State private var showsEditor = false

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
                BadgeGrid(badges: viewModel.displayedBadges, viewModel: viewModel, onSelect: onSelectBadge)
            }

            nextBadgeCard

            Button(action: onShowRecords) {
                sectionHeader("My PR")
            }
            .padding(.top, Constants.Achievements.sectionSpacing)

            if recordsViewModel.records.isEmpty {
                emptyRecordsCard
            } else {
                PersonalRecordStack(viewModel: recordsViewModel) { record in
                    editorLift = record.lift
                    showsEditor = true
                }
            }
        }
        .sheet(isPresented: $showsEditor) {
            PersonalRecordEditor(viewModel: recordsViewModel, lift: editorLift)
        }
    }

    private var emptyRecordsCard: some View {
        Button {
            editorLift = ""
            showsEditor = true
        } label: {
            HStack(spacing: Constants.Achievements.cardSpacing) {
                Constants.Images.prSeal
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Achievements.nextBadgeSize, height: Constants.Achievements.nextBadgeSize)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Log your first PR")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.black)

                    Text("Your card levels up at 135, 225 & 315 lb.")
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
