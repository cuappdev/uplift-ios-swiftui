//
//  BadgeTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Testing
@testable import Uplift

struct BadgeTests {

    private func badge(_ id: String) -> Badge? {
        Badge.all.first { $0.id == id }
    }

    @Test func hasUniqueIds() {
        #expect(Set(Badge.all.map(\.id)).count == Badge.all.count)
    }

    @Test func earnsAtGoal() throws {
        let tenWorkouts = try #require(badge("workouts-10"))

        #expect(!tenWorkouts.isEarned(in: BadgeStats(friendCount: 0, gymDays: 9, longestStreakWeeks: 0)))
        #expect(tenWorkouts.isEarned(in: BadgeStats(friendCount: 0, gymDays: 10, longestStreakWeeks: 0)))
    }

    @Test func usesStatForCategory() throws {
        let stats = BadgeStats(friendCount: 5, gymDays: 0, longestStreakWeeks: 3)

        #expect(try #require(badge("friends-5")).isEarned(in: stats))
        #expect(try #require(badge("streaks-3")).isEarned(in: stats))
        #expect(try #require(badge("workouts-3")).isEarned(in: stats) == false)
    }

    @Test func capsProgressAtGoal() throws {
        let threeWorkouts = try #require(badge("workouts-3"))
        let stats = BadgeStats(friendCount: 0, gymDays: 50, longestStreakWeeks: 0)

        #expect(threeWorkouts.progress(in: stats) == 3)
    }

    @Test func labelsLongStreaksInMonths() throws {
        #expect(try #require(badge("streaks-1")).title == "1 Week")
        #expect(try #require(badge("streaks-7")).title == "7 Weeks")
        #expect(try #require(badge("streaks-8")).title == "2 Months")
        #expect(try #require(badge("streaks-8")).number == 2)
    }

}
