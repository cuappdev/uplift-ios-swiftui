//
//  BadgeShareCard.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BadgeShareCard: View {

    // MARK: - Properties

    let badge: Badge
    let summary: String

    // MARK: - UI

    var body: some View {
        VStack(spacing: Constants.ShareCard.spacing) {
            Spacer()

            BadgeView(badge: badge, isEarned: true, size: Constants.ShareCard.artSize, showsTitle: false)

            VStack(spacing: 8) {
                Text(badge.title)
                    .font(Constants.Fonts.h0)
                    .foregroundStyle(Constants.Colors.black)

                Text(summary)
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black.opacity(0.7))
            }

            Spacer()

            Text("UPLIFT · CORNELL")
                .font(Constants.Fonts.labelBold)
                .tracking(Constants.BadgeDetail.bannerTracking)
                .foregroundStyle(Constants.Colors.black)
        }
        .padding(Constants.ShareCard.padding)
        .frame(width: Constants.ShareCard.size.width, height: Constants.ShareCard.size.height)
        .background(
            LinearGradient(
                colors: [Constants.Colors.yellow, Constants.Colors.lightYellow, Constants.Colors.white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

}
