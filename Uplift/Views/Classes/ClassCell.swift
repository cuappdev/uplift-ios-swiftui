//
//  ClassCell.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/27/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The cell representing a Class used in the classes page.
struct ClassCell: View {

    // MARK: - UI

    var body: some View {
        // TODO: Temporary hardcoded cell
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    Text("8:30 AM")
                        .font(Constants.Fonts.f3)

                    Text("55 min")
                        .font(Constants.Fonts.labelNormal)
                }
                .padding(.trailing, 24)

                VStack(alignment: .leading) {
                    Text("Yoga - Mellow Flow")
                        .font(Constants.Fonts.f2)

                    Text("Teagle Multipurpose Room")
                        .font(Constants.Fonts.labelLight)

                    Spacer()

                    Text("Claire M.")
                        .font(Constants.Fonts.labelLight)
                }

                Spacer()
            }
            .padding(16)
        }
        .frame(height: 100)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
    }

}

#Preview {
    ClassCell()
}
