//
//  QuickStartWorkoutModal.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/31/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct QuickStartWorkoutModal: View {

    // MARK: - Properties

    let onStart: () -> Void
    let onDismiss: () -> Void

    // MARK: - UI

    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Start Your Workout")
                .font(Constants.Fonts.h2)
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Colors.black)

            Button {
                onStart()
            } label: {
                HStack(spacing: 8) {
                    Constants.Images.startWorkout
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text("Start a New Workout")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.black)
                }
                .frame(width: 217, height: 44)
                .background(
                    Capsule()
                        .fill(Constants.Colors.yellow)
                        .upliftShadow(Constants.Shadows.smallLight)
                )
            }

            Button {
                onDismiss()
            } label: {
                Text("Maybe later")
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.gray04)
            }
        }
        .padding(.vertical, 24)
        .frame(width: 249)
    }

}

#Preview {
    QuickStartWorkoutModal(onStart: {}, onDismiss: {})
}
