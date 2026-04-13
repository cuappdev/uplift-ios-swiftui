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
            // Adjust so Monday = index 0 (weekday 2)
            let daysFromMonday = (weekday + 5) % 7
            let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) ?? today
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
                    guard let self else {
                        continuation.resume()
                        return
                    }
                    guard let userFields = result.data?.getUserByNetId?.compactMap({ $0 }).first else {
                        Logger.data.info("fetchUserProfile: no user in getUserByNetId response (netID=\(netID))")
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

        /// Runs `DeleteUser` before `logout()` so the GraphQL request still sends `Authorization`.
        func deleteAccount(onComplete: @escaping (Bool) -> Void = { _ in }) {
            let rawIdDescription = user.map { String(describing: $0.id) } ?? "nil"
            guard let idString = user?.id, let userId = Int(idString) else {
                Logger.data.critical(
                    "deleteAccount: No user ID or invalid Int(rawGraphQLId=\(rawIdDescription))"
                )
                onComplete(false)
                return
            }

            let netId = user?.netId ?? "nil"
            let sessionNetID = UserSessionManager.shared.netID ?? "nil"
            let hasAccessToken = UserSessionManager.shared.accessToken != nil
            Logger.data.info(
                "deleteAccount DeleteUser mutation: userId=\(userId) rawGraphQLId=\(rawIdDescription) profileNetId=\(netId) sessionNetID=\(sessionNetID) hasAccessToken=\(hasAccessToken)"
            )

            Network.client.mutationPublisher(mutation: DeleteUserMutation(userId: userId))
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("deleteAccount error: \(error)")
                        onComplete(false)
                    }
                } receiveValue: { [weak self] _ in
                    guard let self else {
                        onComplete(false)
                        return
                    }
                    Logger.data.info("Successfully deleted account")
                    UserSessionManager.shared.logout()
                    self.showSettingsSheet = false
                    self.user = nil
                    self.workouts = []
                    onComplete(true)
                }
                .store(in: &queryBag)
        }
    }
}
