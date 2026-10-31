//
//  MinimizedWorkoutBar.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/30/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MinimizedWorkoutBar: View {

    // MARK: - Properties

    @ObservedObject var viewModel: WorkoutInProgressView.ViewModel

    let namespace: Namespace.ID

    // MARK: - UI

    var body: some View {
        Button {
            viewModel.isExpanded = true
        } label: {
            ZStack {
                HStack {
                    chevron
                        .fadeInOnAppear()

                    Spacer()
                }

                details
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(card)
        }
        .buttonStyle(.plain)
    }

    private var card: some View {
        Constants.WorkoutInProgress.cardShape
            .fill(Constants.Colors.white)
            .overlay {
                Constants.WorkoutInProgress.cardShape
                    .strokeBorder(Constants.Colors.gray01, lineWidth: 1)
                    .mask {
                        Rectangle()
                            .padding(.bottom, 1)
                    }
            }
            .matchedGeometryEffect(id: Constants.WorkoutInProgress.cardId, in: namespace)
            .upliftShadow(Constants.Shadows.mediumDark)
    }

    private var chevron: some View {
        Constants.Images.chevronDown
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .rotationEffect(.degrees(180))
            .foregroundStyle(Constants.Colors.black)
    }

    private var details: some View {
        VStack(spacing: 4) {
            Text(Constants.WorkoutInProgress.title)
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .matchedGeometryEffect(id: Constants.WorkoutInProgress.titleId, in: namespace)

            TimelineView(.periodic(from: viewModel.activeWorkout?.startDate ?? .now, by: 1)) { context in
                Text("Duration: \(viewModel.durationText(at: context.date))")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.gray04)
                    .onChange(of: context.date) { date in
                        viewModel.finishIfExpired(at: date)
                    }
            }
            .fadeInOnAppear()
        }
    }

}

@available(iOS 17.0, *)
#Preview {
    @Previewable @Namespace var namespace
    let viewModel = WorkoutInProgressView.ViewModel(defaults: UserDefaults(suiteName: "preview") ?? .standard)
    viewModel.start(gym: nil, workoutId: nil)
    return MinimizedWorkoutBar(viewModel: viewModel, namespace: namespace)
}
