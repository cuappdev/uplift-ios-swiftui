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
        @Published var profile: UserProfile?
        @Published var showSettingsSheet = false
        @Published var workoutHistory: [WorkoutHistory] = []
        @Published var weeklyWorkouts: WeeklyWorkoutData = WeeklyWorkoutData(
            currentWeekWorkouts: 0,
            weeklyGoal: 5,
            weekDates: []
        )
        @Published var totalWorkouts: Int = 0
        @Published var streaks: Int = 14
        @Published var badges: Int = 6

        /// dummy data
        func fetchUserProfile() {
            self.profile = DummyData.ProfileViewData.profile
            self.totalWorkouts = DummyData.ProfileViewData.totalWorkouts
            self.streaks = DummyData.ProfileViewData.streaks
            self.badges = DummyData.ProfileViewData.badges
            self.weeklyWorkouts = DummyData.ProfileViewData.weeklyWorkouts
            self.workoutHistory = DummyData.ProfileViewData.workoutHistory
        }

        private func createDate(day: Int) -> Date {
            var components = DateComponents()
            components.year = 2024
            components.month = 3
            components.day = day
            return Calendar.current.date(from: components) ?? Date()
        }
    }
}
