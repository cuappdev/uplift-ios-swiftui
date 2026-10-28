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
import UIKit

// MARK: - ViewModel
extension ProfileView {
    class ViewModel: ObservableObject {

        // MARK: - Properties

        private var queryBag = Set<AnyCancellable>()

        @Published var user: User?
        @Published var workouts: [Workout] = []
        @Published var profileImage: UIImage?
        @Published var showSettingsSheet = false
        @Published var showDeleteAccountAlert = false

        // MARK: - Computed Properties

        var totalGymDays: Int {
            user?.totalGymDays ?? 0
        }

        var activeStreak: Int {
            user?.activeStreak ?? 0
        }

        var weeklyProgress: WeeklyProgress {
            WeeklyProgress(workouts: workouts, goal: user?.workoutGoal)
        }

        /// Returns the user profile image's URL from the encoded image given.
        var profileImageHTTPURL: URL? {
            guard let raw = user?.encodedImage?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !raw.isEmpty,
                  let url = URL(string: raw),
                  let scheme = url.scheme?.lowercased(),
                  scheme == "http" || scheme == "https" else { return nil }
            return url
        }

        /// The most recent workouts sorted by newest first.
        var recentWorkouts: [Workout] {
            Array(workouts.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }.prefix(5))
        }

        // MARK: - Requests

        func fetchUserProfile() async {
            guard let netID = UserSessionManager.shared.netID else {
                Logger.data.critical("fetchUserProfile: No netID found in session")
                return
            }

            await withCheckedContinuation { continuation in
                var cancellable: AnyCancellable?
                var didResume = false

                cancellable = Network.client.queryPublisher(
                    query: GetUserByNetIdQuery(netId: .some(netID)),
                    cachePolicy: .fetchIgnoringCacheData,
                    queue: .main
                )
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("fetchUserProfile error: \(error)")
                    }

                    if !didResume {
                        didResume = true
                        continuation.resume()
                    }

                    _ = cancellable
                } receiveValue: { [weak self] result in
                    guard let self else {
                        if !didResume {
                            didResume = true
                            continuation.resume()
                        }
                        return
                    }

                    guard let userFields = result.data?.getUserByNetId?.compactMap({ $0 }).first else {
                        Logger.data.info("fetchUserProfile: no user in getUserByNetId response (netID=\(netID))")

                        if !didResume {
                            didResume = true
                            continuation.resume()
                        }
                        return
                    }

                    self.user = User(from: userFields.fragments.userFields)
                    self.workouts = self.user?.workoutHistory ?? []

                    if !didResume {
                        didResume = true
                        continuation.resume()
                    }
                }
            }
        }

        /// Updates the profile image for this user.
        func editProfileImage() {
            guard let user = user,
                  let userId = Int(user.id) else { return }

            let resizedImage = profileImage?.resized()
            let base64Image: String? = resizedImage?
                .jpegData(compressionQuality: 0.2)?
                .base64EncodedString()

            Network.client.mutationPublisher(
                mutation: EditUserMutation(
                    userId: userId,
                    email: user.email.map { GraphQLNullable.some($0) } ?? .none,
                    encodedImage: base64Image.map { GraphQLNullable.some($0) } ?? .none,
                    name: GraphQLNullable(stringLiteral: user.name)
                )
            )
            .compactMap(\.data?.editUser)
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in ProfileViewModel.editUser: \(error)")
                }
            } receiveValue: { _ in
#if DEBUG
                Logger.data.log("Edit profile image successful")
#endif
            }
            .store(in: &queryBag)
        }

        /// Deletes the backend user. Callers log out on success, so the request still sends `Authorization`.
        func deleteAccount(onComplete: @escaping (Bool) -> Void = { _ in }) {
            let rawIdDescription = user.map { String(describing: $0.id) } ?? "nil"
            guard let idString = user?.id, let userId = Int(idString) else {
                Logger.data.critical(
                    "deleteAccount: No user ID or invalid Int(rawGraphQLId=\(rawIdDescription))"
                )
                onComplete(false)
                return
            }

            var cancellable: AnyCancellable?
            cancellable = Network.client.mutationPublisher(
                mutation: DeleteUserMutation(userId: userId),
                queue: .main
            )
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("deleteAccount error: \(error)")
                        onComplete(false)
                    }
                    cancellable?.cancel()
                    cancellable = nil
                } receiveValue: { [weak self] _ in
                    Logger.data.info("Successfully deleted account")
                    self?.showSettingsSheet = false
                    self?.user = nil
                    self?.workouts = []
                    onComplete(true)
                }
        }

    }
}
