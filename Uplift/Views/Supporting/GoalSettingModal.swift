//
//  GoalSettingModal.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/23/26.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A modal for the goal setting warning popup.
struct GoalSettingModal: View {

    // MARK: - Properties

    let onContinue: () -> Void
    let onCancel: () -> Void

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                Constants.Images.clockOutlined
                    .resizable()
                    .frame(width: 36, height: 36)

                Text("Goals can only be changed again after 30 days, do you want to continue?")
                    .font(Constants.Fonts.bodyNormal)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.Colors.black)
                    .padding(.horizontal, 20)

                Button {
                    onContinue()
                } label: {
                    Text("Continue")
                        .frame(width: 209, height: 41)
                        .foregroundStyle(Constants.Colors.white)
                        .font(Constants.Fonts.h3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Constants.Colors.black)
                        )
                }

                Button {
                    onCancel()
                } label: {
                    Text("Back")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h3)
                }
            }

            Button {
                onCancel()
            } label: {
                Constants.Images.crossThin
                    .foregroundColor(Constants.Colors.black)
                    .frame(width: 32, height: 32)
            }
            .offset(x: -10, y: -10)
        }
        .frame(width: 249, height: 246)
    }

}

#Preview {
    VStack {
        GoalSettingModal(onContinue: {}, onCancel: {})
    }
    .background(Constants.Colors.gray05)
}
