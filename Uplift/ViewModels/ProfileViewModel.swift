//
//  ProfileViewModel.swift
//  Uplift
//
//  Created by jiwon jeong on 3/6/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: - ViewModel
extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var user: User?
        @Published var workouts: [Workout] = []
        @Published var showSettingsSheet = false
        @Published var currentWeekWorkouts: Int = 0

        // MARK: - Computed Properties

        var totalGymDays: Int {
            user?.totalGymDays ?? 0
        }

        var activeStreak: Int {
            user?.activeStreak ?? 0
        }

        var workoutGoal: Int {
            user?.workoutGoal ?? 5
        }

        var weekDates: [Date] {
            let calendar = Calendar.current
            let today = Date()
            let weekday = calendar.component(.weekday, from: today)
            let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        }

        var workoutsThisWeek: [Workout] {
            let calendar = Calendar.current
            let today = Date()
            let weekday = calendar.component(.weekday, from: today)
            let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
            return workouts.filter { workout in
                guard let date = ISO8601DateFormatter().date(from: workout.workoutTime) else { return false }
                return date >= startOfWeek && date <= today
            }
        }

        // MARK: - Functions

        func fetchUserProfile() {
            self.user = DummyData.uplift.dummyUser
            self.workouts = DummyData.uplift.dummyWorkouts
            self.currentWeekWorkouts = workoutsThisWeek.count
        }
    }
}
