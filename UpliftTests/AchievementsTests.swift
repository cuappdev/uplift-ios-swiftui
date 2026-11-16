//
//  AchievementsTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

@MainActor
struct AchievementsTests {

    private let defaults = UserDefaults(suiteName: UUID().uuidString) ?? .standard

    private func makeUser(gymDays: Int, streakWeeks: Int) -> User {
        User(
            id: "1",
            email: nil,
            name: "Test",
            netId: "abc123",
            workoutGoal: 3,
            activeStreak: 0,
            maxStreak: streakWeeks,
            lastStreak: 0,
            lastGoalChange: "",
            encodedImage: nil,
            goalHistory: nil,
            totalGymDays: gymDays,
            streakStart: nil,
            workoutHistory: []
        )
    }

    private func makeViewModel(now: Date) -> AchievementsView.ViewModel {
        AchievementsView.ViewModel(defaults: defaults, now: { now })
    }

    @Test func displaysHardestEarnedBadges() {
        let viewModel = makeViewModel(now: .distantFuture)
        viewModel.update(user: makeUser(gymDays: 100, streakWeeks: 26), friendCount: 50)

        let displayed = viewModel.displayedBadges.map(\.id)
        #expect(displayed.count == Constants.Badges.displayedCount)
        #expect(displayed.contains("workouts-100"))
        #expect(displayed.contains("streaks-26"))
        #expect(!displayed.contains("workouts-3"))
        #expect(displayed.contains("friends-50"))
    }

    @Test func picksClosestBadgeAsNext() {
        let viewModel = makeViewModel(now: .distantFuture)
        viewModel.update(user: makeUser(gymDays: 9, streakWeeks: 0), friendCount: 0)

        #expect(viewModel.nextBadge?.id == "workouts-10")
        #expect(viewModel.nextBadge.map(viewModel.remaining) == 1)
    }

    @Test func keepsFoundingMemberAfterDeadline() {
        let viewModel = makeViewModel(now: .distantPast)
        viewModel.update(user: makeUser(gymDays: 0, streakWeeks: 0), friendCount: 0)

        let later = AchievementsView.ViewModel(defaults: defaults, now: { .distantFuture })
        later.update(user: makeUser(gymDays: 0, streakWeeks: 0), friendCount: 0)

        #expect(later.stats.isFoundingMember)
    }

    @Test func recordsDateForBadgesWithoutHistory() throws {
        let earnedOn = Date(timeIntervalSince1970: 1_800_000_000)
        let viewModel = makeViewModel(now: earnedOn)
        viewModel.update(user: makeUser(gymDays: 0, streakWeeks: 1), friendCount: 0)

        let later = AchievementsView.ViewModel(defaults: defaults, now: { .distantFuture })
        later.update(user: makeUser(gymDays: 0, streakWeeks: 1), friendCount: 0)

        let oneWeek = try #require(Badge.all.first { $0.id == "streaks-1" })
        #expect(later.earnedDate(of: oneWeek) == earnedOn)
    }

    @Test func summarizesLockedAndSecretBadges() throws {
        let viewModel = makeViewModel(now: .distantFuture)
        viewModel.update(user: makeUser(gymDays: 7, streakWeeks: 0), friendCount: 0)

        let tenWorkouts = try #require(Badge.all.first { $0.id == "workouts-10" })
        let nightOwl = try #require(Badge.all.first { $0.id == "special-night-owl" })

        #expect(viewModel.summary(of: tenWorkouts) == "7/10")
        #expect(viewModel.summary(of: nightOwl) == "Secret badge")
        #expect(viewModel.detail(of: nightOwl) != nightOwl.detail)
    }

    @Test func celebratesOnlyNewBadges() throws {
        let viewModel = makeViewModel(now: .distantPast)
        viewModel.update(user: makeUser(gymDays: 3, streakWeeks: 0), friendCount: 0)

        #expect(viewModel.takeUnseenBadge()?.id == "special-founding")
        #expect(viewModel.takeUnseenBadge() == nil)

        viewModel.update(user: makeUser(gymDays: 20, streakWeeks: 0), friendCount: 0)
        #expect(viewModel.takeUnseenBadge()?.id == "workouts-20")
        #expect(viewModel.takeUnseenBadge() == nil)
    }

    @Test func clearsStatsWithoutUser() {
        let viewModel = makeViewModel(now: .distantFuture)
        viewModel.update(user: makeUser(gymDays: 10, streakWeeks: 0), friendCount: 0)
        viewModel.update(user: nil, friendCount: 0)

        #expect(viewModel.earnedBadges.isEmpty)
    }

}
