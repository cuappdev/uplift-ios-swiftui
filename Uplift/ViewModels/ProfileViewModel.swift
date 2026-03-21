//
//  ProfileViewModel.swift
//  Uplift
//
//  Created by jiwon jeong on 3/6/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import UpliftAPI
import os

// MARK: - ViewModel
extension ProfileView {
    class ViewModel: ObservableObject {

        // MARK: - Properties

        private var queryBag = Set<AnyCancellable>()

        @Published var user: User?
        @Published var workouts: [Workout] = []
        @Published var showSettingsSheet = false
        @Published var showDeleteAccountAlert = false
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

        var weekDates: [Foundation.Date] {
            let calendar = Calendar.current
            let today = Foundation.Date()
            let weekday = calendar.component(.weekday, from: today)
            let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        }

        var workoutsThisWeek: [Workout] {
            let calendar = Calendar.current
            let today = Foundation.Date()
            let weekday = calendar.component(.weekday, from: today)
            let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
            return workouts.filter { workout in
                guard let date = ISO8601DateFormatter().date(from: workout.workoutTime) else { return false }
                return date >= startOfWeek && date <= today
            }
        }

        // MARK: - Functions

        func fetchUserProfile() async {
            guard let netID = UserSessionManager.shared.netID else {
                Logger.data.critical("fetchUserProfile: No netID found in session")
                return
            }

            await withCheckedContinuation { continuation in
                Network.client.queryPublisher(
                    query: GetUserByNetIdQuery(netId: .some(netID)),
                    cachePolicy: .fetchIgnoringCacheData,
                    queue: .main
                )
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("fetchUserProfile error: \(error)")
                        continuation.resume()
                    }
                } receiveValue: { [weak self] result in
                    guard let self, let userFields = result.data?.getUserByNetId?.compactMap({ $0 }).first else {
                        continuation.resume()
                        return
                    }
                    self.user = User(from: userFields.fragments.userFields)
                    self.workouts = self.user?.workoutHistory ?? []
                    self.currentWeekWorkouts = self.workoutsThisWeek.count
                    continuation.resume()
                }
                .store(in: &queryBag)
            }
        }

        func deleteAccount() {
            guard let idString = user?.id, let userId = Int(idString) else {
                Logger.data.critical("deleteAccount: No user ID found or invalid ID format")
                return
            }

            UserSessionManager.shared.logout()
            showSettingsSheet = false
            user = nil
            workouts = []

            Network.client.mutationPublisher(mutation: DeleteUserMutation(userId: userId))
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("deleteAccount error: \(error)")
                    }
                } receiveValue: { _ in
                    Logger.data.info("Successfully deleted account")
                }
                .store(in: &queryBag)
        }
    }
}
