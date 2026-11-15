//
//  BadgeGrid.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BadgeGrid: View {

    // MARK: - Properties

    let badges: [Badge]
    @ObservedObject var viewModel: AchievementsView.ViewModel
    let onSelect: (Badge) -> Void

    // MARK: - UI

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: Constants.Badges.gridColumns),
            spacing: Constants.Badges.gridSpacing
        ) {
            ForEach(badges) { badge in
                Button {
                    onSelect(badge)
                } label: {
                    BadgeView(
                        badge: badge,
                        isEarned: viewModel.isEarned(badge),
                        progress: viewModel.progress(of: badge)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

}
