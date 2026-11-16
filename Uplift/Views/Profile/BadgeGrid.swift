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
    let stats: BadgeStats
    var onSelect: ((Badge) -> Void)?

    // MARK: - UI

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: Constants.Badges.gridColumns),
            spacing: Constants.Badges.gridSpacing
        ) {
            ForEach(badges) { badge in
                Button {
                    onSelect?(badge)
                } label: {
                    BadgeView(
                        badge: badge,
                        isEarned: badge.isEarned(in: stats),
                        progress: badge.progressFraction(in: stats)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(onSelect == nil)
            }
        }
    }

}
