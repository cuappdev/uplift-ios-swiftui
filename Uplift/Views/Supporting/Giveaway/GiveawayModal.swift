//
//  GiveawayModal.swift
//  Uplift
//
//  Created by Vin Bui on 4/15/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View representing the giveaway modal cell that is tapped on.
struct GiveawayModal: View {

    // MARK: - UI

    var body: some View {
        HStack(spacing: 16) {
            Constants.Images.logoWhite
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text("Uplift Giveaway!")
                    .font(Constants.Fonts.h2)

                Text("Tell us who you are for a chance to win special prizes!!")
                    .font(Constants.Fonts.labelNormal)
            }
            .foregroundStyle(Constants.Colors.white)
            .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            Constants.Images.giveawayModalBackground
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .upliftShadow(Constants.Shadows.normalLight)
    }

}

#Preview {
    GiveawayModal()
}
