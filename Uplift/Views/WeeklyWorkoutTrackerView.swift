//
//  WeeklyWorkoutTrackerView.swift
//  Uplift
//
//  Created by jiwon jeong on 3/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WeeklyWorkoutTrackerView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ProfileView.ViewModel
    @State private var animationProgress: [Double] = Array(repeating: 0, count: 7)

    // Weekday abbreviations
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    // Days that have workouts
    @State private var workoutDays: [Bool] = [false, false, false, false, false, false, false]

    // Animation timing
    private let animationDuration: Double = 0.5
    private let delayBetweenDays: Double = 0.3

    // Circle dimensions
    private let circleSize: CGFloat = 24
    private let lineWidth: CGFloat = 2
    private let spacing: CGFloat = 26.5
    private let verticalSpacing: CGFloat = 2

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: verticalSpacing) {
                // Weekday abbreviations
                HStack(spacing: spacing) {
                    ForEach(weekdays.indices, id: \.self) { index in
                        Text(weekdays[index])
                            .font(Constants.Fonts.labelSemibold)
                            .foregroundColor(Constants.Colors.black)
                            .frame(width: circleSize)
                            .lineLimit(1)
                            .minimumScaleFactor(0.82)
                    }
                }

                // Workout circles with connecting lines
                ZStack {
                    HStack(spacing: 0) {
                        ForEach(0..<6, id: \.self) { _ in
                            HStack(spacing: 0) {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: circleSize)

                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: spacing, height: lineWidth)
                            }
                        }

                        Circle()
                            .fill(Color.clear)
                            .frame(width: circleSize)
                    }

                    // Workout day circles
                    HStack(spacing: spacing) {
                        ForEach(weekdays.indices, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: circleSize, height: circleSize)

                                if workoutDays[index] {
                                    Circle()
                                        .fill(Constants.Colors.yellow)
                                        .frame(width: circleSize, height: circleSize)
                                        .scaleEffect(animationProgress[index])
                                        .opacity(animationProgress[index])
                                }

                                if workoutDays[index] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                        .scaleEffect(animationProgress[index])
                                        .opacity(animationProgress[index])
                                }
                            }
                        }
                    }
                }

                HStack(spacing: spacing) {
                    ForEach(weekdays.indices, id: \.self) { index in
                        Text("\(25 + index)")
                            .font(Constants.Fonts.labelNormal)
                            .frame(width: circleSize, height: 20)
                            .foregroundColor(Constants.Colors.black)
                    }
                }
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 15)
        .onAppear {
            if viewModel.workoutHistory.isEmpty {
                viewModel.fetchUserProfile()
            }
        }
        .onReceive(viewModel.$workoutHistory) { workouts in
            if !workouts.isEmpty {
                determineWorkoutDays()
                Task {
                    await animateWorkouts()
                }
            }
        }
    }

    /// Determines which days of the week have completed workouts and updates the UI accordingly
    private func determineWorkoutDays() {
        let workoutDaysSet = Set(viewModel.workoutHistory.compactMap { workout -> Int? in
            guard let date = Date.fromString(workout.date) else { return nil }
            return Calendar.current.component(.day, from: date)
        })

        weekdays.indices.forEach { index in
            let day = 25 + index
            workoutDays[index] = workoutDaysSet.contains(day)
        }

        // Reset animation progress
        animationProgress = Array(repeating: 0, count: 7)
    }

    /// Animates the workout day indicators sequentially from left to right with fade-in effect
    private func animateWorkouts() async {
        for index in weekdays.indices where workoutDays[index] {
            // Add delay between animations
            try? await Task.sleep(for: .seconds(delayBetweenDays))

            await MainActor.run {
                withAnimation(.easeIn(duration: animationDuration)) {
                    animationProgress[index] = 1.0
                }
            }
        }
    }
}

#Preview {
    let viewModel = ProfileView.ViewModel()
    viewModel.fetchUserProfile()

    return WeeklyWorkoutTrackerView(viewModel: viewModel)
        .frame(height: 100)
        .padding()
        .background(Color.white)
}
