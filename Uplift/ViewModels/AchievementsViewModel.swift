//
//  AchievementsViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

extension AchievementsView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published private(set) var stats = BadgeStats(friendCount: 0, gymDays: 0, longestStreakWeeks: 0)

        private let defaults: UserDefaults
        private let now: () -> Date

        init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
            self.defaults = defaults
            self.now = now
        }

        var earnedBadges: [Badge] {
            Badge.all.filter(isEarned)
        }

        var displayedBadges: [Badge] {
            let hardest = earnedBadges
                .sorted { tier(of: $0) > tier(of: $1) }
                .prefix(Constants.Badges.displayedCount)
            return earnedBadges.filter(hardest.contains)
        }

        var nextBadge: Badge? {
            Badge.all
                .filter { !$0.isSecret && !isEarned($0) }
                .min { (progress(of: $1), -$1.goal) < (progress(of: $0), -$0.goal) }
        }

        // MARK: - Functions

        func update(user: User?, friendCount: Int) {
            guard let user else {
                stats = BadgeStats(friendCount: 0, gymDays: 0, longestStreakWeeks: 0)
                return
            }

            if now() < Constants.Badges.foundingDeadline {
                defaults.set(true, forKey: Constants.UserDefaultsKeys.foundingMember)
            }

            stats = BadgeStats(
                friendCount: friendCount,
                gymDays: user.totalGymDays,
                longestStreakWeeks: user.maxStreak,
                checkIns: user.workoutHistory.compactMap { workout in
                    Date.fromBackend(workout.workoutTime).map {
                        BadgeStats.CheckIn(date: $0, gymName: workout.gymName)
                    }
                },
                isFoundingMember: defaults.bool(forKey: Constants.UserDefaultsKeys.foundingMember)
            )
        }

        func badges(in category: Badge.Category) -> [Badge] {
            Badge.all.filter { $0.category == category }
        }

        func earnedCount(in category: Badge.Category) -> Int {
            badges(in: category).filter(isEarned).count
        }

        func isEarned(_ badge: Badge) -> Bool {
            badge.isEarned(in: stats)
        }

        func progress(of badge: Badge) -> Double {
            Double(badge.progress(in: stats)) / Double(badge.goal)
        }

        func remaining(for badge: Badge) -> Int {
            badge.goal - badge.progress(in: stats)
        }

        private func tier(of badge: Badge) -> Int {
            badges(in: badge.category).firstIndex(of: badge) ?? 0
        }

    }

}
