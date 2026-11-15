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
        @Published private var recordedDates: [String: Date] = [:]
        @Published private var seenBadgeIds: Set<String>?

        private let defaults: UserDefaults
        private let now: () -> Date

        init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
            self.defaults = defaults
            self.now = now
            let saved = defaults.dictionary(forKey: Constants.UserDefaultsKeys.badgeEarnedDates)
            recordedDates = saved as? [String: Date] ?? [:]
            seenBadgeIds = defaults.stringArray(forKey: Constants.UserDefaultsKeys.seenBadges).map(Set.init)
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

        var unseenBadge: Badge? {
            guard let seenBadgeIds else { return nil }
            return earnedBadges.last { !seenBadgeIds.contains($0.id) }
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
            recordUndatedBadges()
            if seenBadgeIds == nil {
                saveSeenBadges(Set(earnedBadges.filter { $0.metric != .foundingMember }.map(\.id)))
            }
        }

        func markSeen(_ badge: Badge) {
            saveSeenBadges((seenBadgeIds ?? []).union([badge.id]))
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

        func earnedDate(of badge: Badge) -> Date? {
            guard isEarned(badge) else { return nil }
            return stats.achievedDate(for: badge.metric, goal: badge.goal) ?? recordedDates[badge.id]
        }

        func summary(of badge: Badge) -> String {
            if let date = earnedDate(of: badge) {
                return "Earned \(date.formatted(date: .long, time: .omitted))"
            }
            return badge.isSecret ? "Secret badge" : "\(badge.progress(in: stats))/\(badge.goal)"
        }

        func detail(of badge: Badge) -> String {
            badge.isSecret && !isEarned(badge) ? "Keep checking in to discover this one." : badge.detail
        }

        private func recordUndatedBadges() {
            let undated = earnedBadges.filter { earnedDate(of: $0) == nil }
            guard !undated.isEmpty else { return }

            undated.forEach { recordedDates[$0.id] = now() }
            defaults.set(recordedDates, forKey: Constants.UserDefaultsKeys.badgeEarnedDates)
        }

        private func saveSeenBadges(_ ids: Set<String>) {
            seenBadgeIds = ids
            defaults.set(Array(ids), forKey: Constants.UserDefaultsKeys.seenBadges)
        }

        private func tier(of badge: Badge) -> Int {
            badges(in: badge.category).firstIndex(of: badge) ?? 0
        }

    }

}
