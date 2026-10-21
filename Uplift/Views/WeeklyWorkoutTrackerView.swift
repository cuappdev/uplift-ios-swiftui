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
    @State private var workoutDays: [Bool] = [false, false, false, false, false, false, false]

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: Constants.WeeklyWorkoutTracker.verticalSpacing) {
                // Weekday abbreviations
                HStack(spacing: Constants.WeeklyWorkoutTracker.spacing) {
                    ForEach(Constants.WeeklyWorkoutTracker.weekdays.indices, id: \.self) { index in
                        Text(Constants.WeeklyWorkoutTracker.weekdays[index])
                            .font(Constants.Fonts.labelSemibold)
                            .foregroundColor(Constants.Colors.black)
                            .frame(width: Constants.WeeklyWorkoutTracker.circleSize)
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
                                    .frame(width: Constants.WeeklyWorkoutTracker.circleSize)

                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: Constants.WeeklyWorkoutTracker.spacing, height: Constants.WeeklyWorkoutTracker.lineWidth)
                            }
                        }

                        Circle()
                            .fill(Color.clear)
                            .frame(width: Constants.WeeklyWorkoutTracker.circleSize)
                    }

                    HStack(spacing: Constants.WeeklyWorkoutTracker.spacing) {
                        ForEach(Constants.WeeklyWorkoutTracker.weekdays.indices, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: Constants.WeeklyWorkoutTracker.circleSize, height: Constants.WeeklyWorkoutTracker.circleSize)

                                if workoutDays[index] {
                                    Circle()
                                        .fill(Constants.Colors.yellow)
                                        .frame(width: Constants.WeeklyWorkoutTracker.circleSize, height: Constants.WeeklyWorkoutTracker.circleSize)
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

                // Date numbers for current week
                HStack(spacing: Constants.WeeklyWorkoutTracker.spacing) {
                    ForEach(viewModel.weekDates.indices, id: \.self) { index in
                        let day = Calendar.current.component(.day, from: viewModel.weekDates[index])
                        Text("\(day)")
                            .font(Constants.Fonts.labelNormal)
                            .frame(width: Constants.WeeklyWorkoutTracker.circleSize, height: 20)
                            .foregroundColor(Constants.Colors.black)
                    }
                }
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 15)
        .onAppear {
            if !viewModel.workouts.isEmpty {
                determineWorkoutDays()
                Task {
                    await animateWorkouts()
                }
            } else {
                Task {
                    await viewModel.fetchUserProfile()
                }
            }
        }
        .onReceive(viewModel.$workouts) { workouts in
            if !workouts.isEmpty {
                determineWorkoutDays()
                Task {
                    await animateWorkouts()
                }
            }
        }
        .onChange(of: viewModel.currentWeekWorkouts) { _ in
            determineWorkoutDays()
            Task {
                await animateWorkouts()
            }
        }
    }

    // MARK: - Helpers

    /// Determines which days of the current week have completed workouts
    private func determineWorkoutDays() {
        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let calendar = Calendar.current

        // Try both with and without fractional seconds
        let workoutDates = viewModel.workouts.compactMap { workout -> Date? in
            if let date = parser.date(from: workout.workoutTime) { return date }
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            return fallback.date(from: workout.workoutTime)
        }

        workoutDays = viewModel.weekDates.map { weekDate in
            workoutDates.contains { calendar.isDate($0, inSameDayAs: weekDate) }
        }

        animationProgress = Array(repeating: 0, count: 7)
    }

    /// Animates workout day indicators sequentially left to right
    private func animateWorkouts() async {
        for index in Constants.WeeklyWorkoutTracker.weekdays.indices where workoutDays[index] {
            try? await Task.sleep(for: .seconds(Constants.WeeklyWorkoutTracker.delayBetweenDays))

            await MainActor.run {
                withAnimation(.easeIn(duration: Constants.WeeklyWorkoutTracker.animationDuration)) {
                    animationProgress[index] = 1.0
                }
            }
        }
    }
}

#Preview {
    let viewModel = ProfileView.ViewModel()
    Task {
        await viewModel.fetchUserProfile()
    }

    return WeeklyWorkoutTrackerView(viewModel: viewModel)
        .frame(height: 100)
        .padding()
        .background(Color.white)
}
