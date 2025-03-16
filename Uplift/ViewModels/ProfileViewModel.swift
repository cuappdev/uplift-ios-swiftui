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
            self.profile = UserProfile(
                id: "user123",
                name: "Jiwon Jeong"
            )

            self.totalWorkouts = 132
            self.streaks = 14
            self.badges = 6

            // Create dates for the week
            let weekDates = [
                self.createDate(day: 25),
                self.createDate(day: 26),
                self.createDate(day: 27),
                self.createDate(day: 28),
                self.createDate(day: 29),
                self.createDate(day: 30),
                self.createDate(day: 31)
            ]

            self.weeklyWorkouts = WeeklyWorkoutData(
                currentWeekWorkouts: 0,
                weeklyGoal: 5,
                weekDates: weekDates
            )

            self.workoutHistory = [
                WorkoutHistory(
                    id: "workout1",
                    location: "Helen Newman",
                    time: "6:30 PM",
                    date: "Fri Mar 29, 2024"
                ),
                WorkoutHistory(
                    id: "workout2",
                    location: "Teagle Up",
                    time: "7:15 PM",
                    date: "Thu Mar 28, 2024"
                ),
                WorkoutHistory(
                    id: "workout3",
                    location: "Helen Newman",
                    time: "6:32 PM",
                    date: "Tue Mar 26, 2024"
                ),
                WorkoutHistory(
                    id: "workout4",
                    location: "Toni Morrison",
                    time: "7:37 PM",
                    date: "Sun Mar 24, 2024"
                ),
                WorkoutHistory(
                    id: "workout5",
                    location: "Helen Newman",
                    time: "10:02 AM",
                    date: "Sat Mar 23, 2024"
                )
            ]
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
