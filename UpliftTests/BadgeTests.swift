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
        #expect(stats.achievedDate(for: .gymsVisited, goal: 2) == (try checkIn(8, 22, "Noyes")).date)
        let thirdDay = calendar.startOfDay(for: try checkIn(28, 12, "Noyes").date)
        #expect(stats.achievedDate(for: .gymDays, goal: 3) == thirdDay)
        #expect(stats.achievedDate(for: .gymDays, goal: 4) == nil)
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

    @Test func countsStrengthMilestonesFromRecords() {
        func entry(_ weight: Double, day: Double) -> PersonalRecord.Entry {
            PersonalRecord.Entry(date: Date(timeIntervalSince1970: day * 86_400), reps: 1, weight: weight)
        }

        let stats = BadgeStats(
            friendCount: 0,
            gymDays: 0,
            longestStreakWeeks: 0,
            records: [
                PersonalRecord(
                    lift: "Bench Press",
                    entries: [entry(185, day: 1), entry(175, day: 2), entry(245, day: 3)]
                ),
                PersonalRecord(lift: "Squat", entries: [entry(315, day: 4)]),
                PersonalRecord(lift: "Deadlift", entries: [entry(445, day: 5)])
            ]
        )

        #expect(stats.value(for: .personalRecordsSet) == 4)
        #expect(stats.value(for: .heaviestLift) == 445)
        #expect(stats.value(for: .bigThreeLogged) == 3)
        #expect(stats.value(for: .bigThreeTotal) == 1005)
        #expect(stats.achievedDate(for: .heaviestLift, goal: 225) == entry(245, day: 3).date)
    }

    @Test func countsMuscleWeeks() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/New_York"))

        func checkIn(_ day: Int, _ muscles: Set<MuscleCategory>) throws -> BadgeStats.CheckIn {
            let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: 12)))
            return BadgeStats.CheckIn(date: date, gymName: "Teagle", muscles: muscles)
        }

        let stats = BadgeStats(
            friendCount: 0,
            gymDays: 0,
            longestStreakWeeks: 0,
            checkIns: [
                try checkIn(2, [.leg, .arm]),
                try checkIn(4, [.back, .chest, .shoulder]),
                try checkIn(10, [.leg]),
                try checkIn(24, [.leg])
            ],
            calendar: calendar
        )

        #expect(stats.value(for: .muscleDays(.leg)) == 3)
        #expect(stats.value(for: .legDayWeeks) == 2)
        #expect(stats.value(for: .fullBodyWeeks) == 1)
    }

}
