//
//  WorkoutProgressArc.swift
//  Uplift
//
//  Created by jiwon jeong on 3/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

// Unit Circle Animation
struct WorkoutProgressArc: View {

    // MARK: - Properties

    @State private var arcProgress: Double = 0
    @State private var dotRotation: Double = 0

    @ObservedObject var viewModel: ProfileView.ViewModel

    let radius: CGFloat = 126

    // MARK: - UI

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    Color.gray.opacity(0.2),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: radius * 2, height: radius * 2)
                .rotationEffect(.degrees(180))

            // Progress arc - yellow portion
            Circle()
                .trim(from: 0, to: 0.5 * arcProgress)
                .stroke(
                    Constants.Colors.yellow,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: radius * 2, height: radius * 2)
                .rotationEffect(.degrees(180))

            // Yellow dot
            ZStack {
                Circle()
                    .fill(Constants.Colors.yellow)
                    .frame(width: 26, height: 26)

                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
            }
            .offset(x: -radius)
            .rotationEffect(.degrees(dotRotation))
            .animation(.easeOut(duration: 1.5), value: dotRotation)

            VStack(spacing: 8) {
                // Value
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("\(viewModel.currentWeekWorkouts)")
                        .font(Constants.Fonts.p1)
                        .foregroundColor(.black)

                    Text("/ \(viewModel.user?.workoutGoal ?? 5)")
                        .font(Constants.Fonts.h1)
                        .foregroundColor(.gray)
                        .padding(.leading, 2)
                }

                // Label
                Text("Days this week")
                    .font(Constants.Fonts.labelNormal)
                    .foregroundColor(.gray)
            }
            .offset(y: -40)
        }
        .frame(width: radius * 2, height: radius * 2)
        .onAppear {
            animateProgress()
        }
        .onChange(of: viewModel.currentWeekWorkouts) { _ in
            animateProgress()
        }
    }

    // MARK: - Helpers

    private func animateProgress() {
        let goal = Double(viewModel.user?.workoutGoal ?? 5)
        let completed = Double(viewModel.currentWeekWorkouts)
        let progress = min(completed / goal, 1.0)
        let finalRotation = 180 * progress

        withAnimation(.easeOut(duration: 1.5)) {
            arcProgress = progress
            dotRotation = finalRotation
        }
    }
}

#Preview {
    let viewModel = ProfileView.ViewModel()
    Task {
        await viewModel.fetchUserProfile()
    }

    return WorkoutProgressArc(viewModel: viewModel)
        .padding()
        .background(Color.white)
}
