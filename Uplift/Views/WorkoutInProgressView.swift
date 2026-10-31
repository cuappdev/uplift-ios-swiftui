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
    @State private var isContentVisible = false
    @State private var isSlidingAway = false
    @State private var showDiscardAlert = false

    let namespace: Namespace.ID

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header

            Group {
                DividerLine()

                content
            }
            .opacity(isContentVisible ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .contentShape(Rectangle())
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                .fill(Constants.Colors.white)
                .ignoresSafeArea()
                .matchedGeometryEffect(id: Constants.WorkoutInProgress.cardId, in: namespace)
        }
        .offset(y: isSlidingAway ? UIScreen.main.bounds.height : 0)
        .accessibilityAddTraits(.isModal)
        .onAppear {
            withAnimation(.easeOut(duration: 0.25).delay(0.15)) {
                isContentVisible = true
            }
        }
    }

    private var header: some View {
        ZStack {
            Text(Constants.WorkoutInProgress.title)
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .matchedGeometryEffect(id: Constants.WorkoutInProgress.titleId, in: namespace)

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
                .opacity(isContentVisible ? 1 : 0)

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    @ViewBuilder
    private var content: some View {
        if let workout = viewModel.activeWorkout {
            VStack(spacing: 0) {
                subtitle

                timer(for: workout)
                    .padding(.top, 165)

                buttons
                    .padding(.top, 70)
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
                    viewModel.finishIfExpired(at: date)
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
                slideAway {
                    viewModel.finish()
                }
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
        .padding(.horizontal, 24)
        .alert("Discard workout?", isPresented: $showDiscardAlert) {
            Button("Discard", role: .destructive) {
                slideAway {
                    viewModel.discard()
                }
            }

            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Supporting

    private func slideAway(then end: @escaping () -> Void) {
        let duration = Constants.WorkoutInProgress.slideAwayDuration
        withAnimation(.easeIn(duration: duration)) {
            isSlidingAway = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction, end)
        }
    }

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

@available(iOS 17.0, *)
#Preview {
    @Previewable @Namespace var namespace
    let viewModel = WorkoutInProgressView.ViewModel(defaults: UserDefaults(suiteName: "preview") ?? .standard)
    viewModel.start(gym: nil, workoutId: nil)
    return WorkoutInProgressView(viewModel: viewModel, namespace: namespace)
}
