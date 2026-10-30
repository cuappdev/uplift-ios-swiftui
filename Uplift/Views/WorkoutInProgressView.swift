//
//  WorkoutInProgressView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/29/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WorkoutInProgressView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel
    @State private var showDiscardAlert = false

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header

            DividerLine()

            content
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Constants.Colors.white)
    }

    private var header: some View {
        ZStack {
            Text("In Progress")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            HStack {
                Button {
                    viewModel.isExpanded = false
                } label: {
                    Constants.Images.chevronDown
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.black)
                }

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    @ViewBuilder
    private var content: some View {
        if let workout = viewModel.activeWorkout {
            VStack(spacing: 165) {
                subtitle

                VStack(spacing: 70) {
                    timer(for: workout)

                    buttons
                }
            }
        }
    }

    private var subtitle: some View {
        Text(viewModel.subtitleText)
            .font(Constants.Fonts.labelNormal)
            .foregroundStyle(Constants.Colors.gray04)
            .padding(.top, 16)
    }

    private func timer(for workout: ActiveWorkout) -> some View {
        TimelineView(.periodic(from: workout.startDate, by: 1)) { context in
            Text(viewModel.timerText(at: context.date))
                .font(Constants.Fonts.p1)
                .monospacedDigit()
                .foregroundStyle(Constants.Colors.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 30)
                .onChange(of: context.date) { date in
                    if workout.isFinished(at: date) {
                        viewModel.finish()
                    }
                }
        }
    }

    private var buttons: some View {
        VStack(spacing: 26) {
            actionButton(
                icon: Constants.Images.check,
                title: "Finish Workout",
                textColor: Constants.Colors.black,
                background: Constants.Colors.yellow
            ) {
                viewModel.finish()
            }

            actionButton(
                icon: Constants.Images.cross,
                title: "Discard Workout",
                textColor: Constants.Colors.gray04,
                background: Constants.Colors.gray01
            ) {
                showDiscardAlert = true
            }
        }
        .alert("Discard workout?", isPresented: $showDiscardAlert) {
            Button("Discard", role: .destructive) {
                viewModel.discard()
            }

            Button("Cancel", role: .cancel) {}
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Supporting

    private func actionButton(
        icon: Image,
        title: String,
        textColor: Color,
        background: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)

                Text(title)
                    .font(Constants.Fonts.h3)
            }
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(background)
                    .upliftShadow(Constants.Shadows.smallLight)
            )
        }
    }

}

#Preview {
    let viewModel = WorkoutInProgressView.ViewModel(defaults: UserDefaults(suiteName: "preview") ?? .standard)
    viewModel.start(gym: nil, workoutId: nil)
    return WorkoutInProgressView(viewModel: viewModel)
}
