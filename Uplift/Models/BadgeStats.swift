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
    }

    enum Metric: Hashable {
        case comebacks
        case earlyCheckIns
        case foundingMember
        case friends
        case fullWeekends
        case gymDays
        case gymsVisited
        case lateCheckIns
        case longestStreakWeeks
        case topGymVisits
    }

    // MARK: - Properties

    let friendCount: Int
    let gymDays: Int
    let isFoundingMember: Bool
    let longestStreakWeeks: Int

    private let milestones: [Metric: [Date]]

    var comebacks: Int { milestones[.comebacks]?.count ?? 0 }
    var earlyCheckIns: Int { milestones[.earlyCheckIns]?.count ?? 0 }
    var fullWeekends: Int { milestones[.fullWeekends]?.count ?? 0 }
    var gymsVisited: Int { milestones[.gymsVisited]?.count ?? 0 }
    var lateCheckIns: Int { milestones[.lateCheckIns]?.count ?? 0 }
    var topGymVisits: Int { milestones[.topGymVisits]?.count ?? 0 }

    // MARK: - Init

    init(
        friendCount: Int,
        gymDays: Int,
        longestStreakWeeks: Int,
        checkIns: [CheckIn] = [],
        isFoundingMember: Bool = false,
        calendar: Calendar = .current
    ) {
        self.friendCount = friendCount
        self.gymDays = gymDays
        self.longestStreakWeeks = longestStreakWeeks
        self.isFoundingMember = isFoundingMember

        let sorted = checkIns.sorted { $0.date < $1.date }
        let days = Array(Set(sorted.map { calendar.startOfDay(for: $0.date) })).sorted()
        let daySet = Set(days)

        var gymsSeen = Set<String>()
        var visitsByGym: [String: Int] = [:]
        var mostVisits = 0
        var gymsVisitedDates: [Date] = []
        var topGymDates: [Date] = []
        for checkIn in sorted {
            if gymsSeen.insert(checkIn.gymName).inserted {
                gymsVisitedDates.append(checkIn.date)
            }
            visitsByGym[checkIn.gymName, default: 0] += 1
            if let visits = visitsByGym[checkIn.gymName], visits > mostVisits {
                mostVisits = visits
                topGymDates.append(checkIn.date)
            }
        }

        milestones = [
            .comebacks: zip(days, days.dropFirst()).compactMap { previous, next in
                let gap = calendar.dateComponents([.day], from: previous, to: next).day ?? 0
                return gap >= Constants.Badges.comebackGapDays ? next : nil
            },
            .earlyCheckIns: sorted
                .filter { calendar.component(.hour, from: $0.date) < Constants.Badges.earlyCheckInHour }
                .map(\.date),
            .fullWeekends: days.compactMap { day in
                guard calendar.component(.weekday, from: day) == 1,
                      let saturday = calendar.date(byAdding: .day, value: -1, to: day),
                      daySet.contains(saturday) else { return nil }
                return day
            },
            .gymDays: days,
            .gymsVisited: gymsVisitedDates,
            .lateCheckIns: sorted
                .filter { calendar.component(.hour, from: $0.date) >= Constants.Badges.lateCheckInHour }
                .map(\.date),
            .topGymVisits: topGymDates
        ]
    }

    // MARK: - Functions

    func achievedDate(for metric: Metric, goal: Int) -> Date? {
        guard let dates = milestones[metric], goal > 0, goal <= dates.count else { return nil }
        return dates[goal - 1]
    }

    func value(for metric: Metric) -> Int {
        switch metric {
        case .comebacks:
            comebacks
        case .earlyCheckIns:
            earlyCheckIns
        case .foundingMember:
            isFoundingMember ? 1 : 0
        case .friends:
            friendCount
        case .fullWeekends:
            fullWeekends
        case .gymDays:
            gymDays
        case .gymsVisited:
            gymsVisited
        case .lateCheckIns:
            lateCheckIns
        case .longestStreakWeeks:
            longestStreakWeeks
        case .topGymVisits:
            topGymVisits
        }
    }

}
