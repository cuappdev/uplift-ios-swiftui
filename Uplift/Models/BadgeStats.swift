//
//  BadgeStats.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct BadgeStats: Hashable {

    // MARK: - Types

    struct CheckIn: Hashable {
        let date: Date
        let gymName: String
        var muscles: Set<MuscleCategory> = []
    }

    enum Metric: Hashable {
        case bigThreeLogged
        case bigThreeTotal
        case comebacks
        case earlyCheckIns
        case foundingMember
        case friends
        case fullBodyWeeks
        case fullWeekends
        case gymDays
        case gymsVisited
        case heaviestLift
        case lateCheckIns
        case legDayWeeks
        case longestStreakWeeks
        case muscleDays(MuscleCategory)
        case personalRecordsSet
        case topGymVisits
    }

    // MARK: - Properties

    let friendCount: Int
    let gymDays: Int
    let isFoundingMember: Bool
    let longestStreakWeeks: Int

    private let bigThreeTotal: Int
    private let liftEntries: [PersonalRecord.Entry]
    private let milestones: [Metric: [Date]]

    var comebacks: Int { count(.comebacks) }
    var earlyCheckIns: Int { count(.earlyCheckIns) }
    var fullWeekends: Int { count(.fullWeekends) }
    var gymsVisited: Int { count(.gymsVisited) }
    var lateCheckIns: Int { count(.lateCheckIns) }
    var topGymVisits: Int { count(.topGymVisits) }

    // MARK: - Init

    init(
        friendCount: Int,
        gymDays: Int,
        longestStreakWeeks: Int,
        checkIns: [CheckIn] = [],
        records: [PersonalRecord] = [],
        isFoundingMember: Bool = false,
        calendar: Calendar = .current
    ) {
        self.friendCount = friendCount
        self.gymDays = gymDays
        self.longestStreakWeeks = longestStreakWeeks
        self.isFoundingMember = isFoundingMember

        let sorted = checkIns.sorted { $0.date < $1.date }
        let days = Array(Set(sorted.map { calendar.startOfDay(for: $0.date) })).sorted()

        var milestones = Self.checkInMilestones(sorted, days: days, calendar: calendar)
            .merging(Self.muscleMilestones(sorted, calendar: calendar)) { $1 }
            .merging(Self.recordMilestones(records)) { $1 }
        milestones[.gymDays] = days
        self.milestones = milestones

        let bigThree = records.filter { Constants.Badges.bigThree.contains($0.lift.lowercased()) }
        bigThreeTotal = Int(bigThree.compactMap(\.best?.weight).reduce(0, +))
        liftEntries = records.flatMap(\.entries).sorted { $0.date < $1.date }
    }

    var earnedBadges: [Badge] {
        Badge.all.filter { $0.isEarned(in: self) }
    }

    // MARK: - Functions

    func achievedDate(for metric: Metric, goal: Int) -> Date? {
        if metric == .heaviestLift {
            return liftEntries.first { $0.weight >= Double(goal) }?.date
        }
        guard let dates = milestones[metric], goal > 0, goal <= dates.count else { return nil }
        return dates[goal - 1]
    }

    func value(for metric: Metric) -> Int {
        switch metric {
        case .bigThreeTotal:
            bigThreeTotal
        case .foundingMember:
            isFoundingMember ? 1 : 0
        case .friends:
            friendCount
        case .gymDays:
            gymDays
        case .heaviestLift:
            Int(liftEntries.map(\.weight).max() ?? 0)
        case .longestStreakWeeks:
            longestStreakWeeks
        default:
            count(metric)
        }
    }

    private func count(_ metric: Metric) -> Int {
        milestones[metric]?.count ?? 0
    }

    // MARK: - Milestones

    private static func checkInMilestones(
        _ sorted: [CheckIn],
        days: [Date],
        calendar: Calendar
    ) -> [Metric: [Date]] {
        let daySet = Set(days)
        var gymsSeen = Set<String>()
        var visitsByGym: [String: Int] = [:]
        var mostVisits = 0
        var gymsVisited: [Date] = []
        var topGymVisits: [Date] = []

        for checkIn in sorted {
            if gymsSeen.insert(checkIn.gymName).inserted {
                gymsVisited.append(checkIn.date)
            }
            visitsByGym[checkIn.gymName, default: 0] += 1
            if let visits = visitsByGym[checkIn.gymName], visits > mostVisits {
                mostVisits = visits
                topGymVisits.append(checkIn.date)
            }
        }

        return [
            .comebacks: zip(days, days.dropFirst()).compactMap { previous, next in
                let gap = calendar.dateComponents([.day], from: previous, to: next).day ?? 0
                return gap >= Constants.Badges.comebackGapDays ? next : nil
            },
            .earlyCheckIns: sorted
                .filter { calendar.component(.hour, from: $0.date) < Constants.Badges.earlyCheckInHour }
                .map(\.date),
            .fullWeekends: days.filter { day in
                guard calendar.component(.weekday, from: day) == 1,
                      let saturday = calendar.date(byAdding: .day, value: -1, to: day) else { return false }
                return daySet.contains(saturday)
            },
            .gymsVisited: gymsVisited,
            .lateCheckIns: sorted
                .filter { calendar.component(.hour, from: $0.date) >= Constants.Badges.lateCheckInHour }
                .map(\.date),
            .topGymVisits: topGymVisits
        ]
    }

    private static func muscleMilestones(_ sorted: [CheckIn], calendar: Calendar) -> [Metric: [Date]] {
        var milestones: [Metric: [Date]] = [:]
        for muscle in Constants.Badges.trackedMuscles {
            milestones[.muscleDays(muscle)] = sorted.filter { $0.muscles.contains(muscle) }.map(\.date)
        }

        let weeks = Dictionary(grouping: sorted) { checkIn in
            calendar.dateInterval(of: .weekOfYear, for: checkIn.date)?.start ?? checkIn.date
        }
        let sortedWeeks = weeks.keys.sorted()

        milestones[.fullBodyWeeks] = sortedWeeks.filter { week in
            let muscles = weeks[week, default: []].reduce(into: Set<MuscleCategory>()) { $0.formUnion($1.muscles) }
            return muscles.isSuperset(of: Constants.Badges.trackedMuscles)
        }

        var legWeeks: [Date] = []
        var run = 0
        var previous: Date?
        for week in sortedWeeks where weeks[week, default: []].contains(where: { $0.muscles.contains(.leg) }) {
            let isNextWeek = previous.flatMap { calendar.date(byAdding: .weekOfYear, value: 1, to: $0) } == week
            run = isNextWeek ? run + 1 : 1
            previous = week
            if run > legWeeks.count {
                legWeeks.append(week)
            }
        }
        milestones[.legDayWeeks] = legWeeks

        return milestones
    }

    private static func recordMilestones(_ records: [PersonalRecord]) -> [Metric: [Date]] {
        let newRecords = records.flatMap { record in
            record.history.enumerated().compactMap { index, entry in
                let earlier = PersonalRecord(lift: record.lift, entries: Array(record.history.prefix(index)))
                return earlier.beats(entry) ? nil : entry.date
            }
        }

        let bigThreeStarts = records
            .filter { Constants.Badges.bigThree.contains($0.lift.lowercased()) }
            .compactMap { $0.history.first?.date }

        return [
            .bigThreeLogged: bigThreeStarts.sorted(),
            .personalRecordsSet: newRecords.sorted()
        ]
    }

}
