//
//  WeeklyWorkoutTrackerView.swift
//  Uplift
//
//  Created by jiwon jeong on 3/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WeeklyWorkoutTrackerView: View {
    @ObservedObject var viewModel: ProfileView.ViewModel
    @State private var animationProgress: Double = 0

    // Weekday abbreviations
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    // Days that have workouts
    @State private var workoutDays: [Bool] = [false, false, false, false, false, false, false]

    // Animation timing
    private let animationDuration: Double = 0.05
    private let delayBetweenDays: Double = 0.2

    // Circle dimensions
    private let circleSize: CGFloat = 24
    private let lineWidth: CGFloat = 2
    private let spacing: CGFloat = 26
    private let verticalSpacing: CGFloat = 2

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: verticalSpacing) {
                // Weekday abbreviations
                HStack(spacing: 24.5) {
                    ForEach(0..<7, id: \.self) { index in
                        Text(weekdays[index])
                            .font(Constants.Fonts.labelSemibold)
                            .foregroundColor(Constants.Colors.black)
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
                        ForEach(0..<7, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: circleSize, height: circleSize)

                                if workoutDays[index] {
                                    Circle()
                                        .fill(Constants.Colors.yellow)
                                        .frame(width: circleSize, height: circleSize)
                                        .opacity(animationProgress > Double(index) ? 1 : 0)
                                }

                                if workoutDays[index] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                        .opacity(animationProgress > Double(index) ? 1 : 0)
                                }
                            }
                        }
                    }
                }

                HStack(spacing: spacing) {
                    ForEach(0..<7, id: \.self) { index in
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
                animateWorkouts()
            }
        }
    }

    private func determineWorkoutDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd, yyyy"

        let workoutDaysSet = Set(viewModel.workoutHistory.compactMap { workout -> Int? in
            guard let date = formatter.date(from: workout.date) else { return nil }
            return Calendar.current.component(.day, from: date)
        })

        for i in 0..<7 {
            let day = 25 + i
            workoutDays[i] = workoutDaysSet.contains(day)
        }
    }

    private func animateWorkouts() {
        animationProgress = 0

        for i in 0..<7 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * (animationDuration + delayBetweenDays)) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    animationProgress = Double(i + 1)
                }
            }
        }
    }
}

struct WeeklyWorkoutTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProfileView.ViewModel()
        // Pre-load data for preview
        viewModel.fetchUserProfile()

        return WeeklyWorkoutTrackerView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
    }
}
