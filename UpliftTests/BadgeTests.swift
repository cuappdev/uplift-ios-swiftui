//
//  BadgeTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
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

    @Test func countsSpecialCheckIns() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/New_York"))

        func checkIn(_ day: Int, _ hour: Int, _ gym: String) throws -> BadgeStats.CheckIn {
            let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: hour)))
            return BadgeStats.CheckIn(date: date, gymName: gym)
        }

        let stats = BadgeStats(
            friendCount: 0,
            gymDays: 0,
            longestStreakWeeks: 0,
            checkIns: [
                try checkIn(7, 6, "Teagle"),
                try checkIn(8, 22, "Noyes"),
                try checkIn(28, 12, "Noyes")
            ],
            calendar: calendar
        )

        #expect(stats.earlyCheckIns == 1)
        #expect(stats.lateCheckIns == 1)
        #expect(stats.fullWeekends == 1)
        #expect(stats.gymsVisited == 2)
        #expect(stats.topGymVisits == 2)
        #expect(stats.comebacks == 1)
    }

    @Test func earnsFoundingMemberOnlyWhenFlagged() throws {
        let founding = try #require(badge("special-founding"))

        #expect(!founding.isEarned(in: BadgeStats(friendCount: 0, gymDays: 0, longestStreakWeeks: 0)))
        #expect(founding.isEarned(in: BadgeStats(
            friendCount: 0,
            gymDays: 0,
            longestStreakWeeks: 0,
            isFoundingMember: true
        )))
    }

    @Test func labelsLongStreaksInMonths() throws {
        #expect(try #require(badge("streaks-1")).title == "1 Week")
        #expect(try #require(badge("streaks-7")).title == "7 Weeks")
        #expect(try #require(badge("streaks-8")).title == "2 Months")
        #expect(try #require(badge("streaks-8")).number == 2)
    }

}
