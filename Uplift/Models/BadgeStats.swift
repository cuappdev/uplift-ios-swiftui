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

    let comebacks: Int
    let earlyCheckIns: Int
    let friendCount: Int
    let fullWeekends: Int
    let gymDays: Int
    let gymsVisited: Int
    let isFoundingMember: Bool
    let lateCheckIns: Int
    let longestStreakWeeks: Int
    let topGymVisits: Int

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

        let hours = checkIns.map { calendar.component(.hour, from: $0.date) }
        earlyCheckIns = hours.filter { $0 < Constants.Badges.earlyCheckInHour }.count
        lateCheckIns = hours.filter { $0 >= Constants.Badges.lateCheckInHour }.count

        let visitsByGym = Dictionary(grouping: checkIns, by: \.gymName)
        gymsVisited = visitsByGym.count
        topGymVisits = visitsByGym.values.map(\.count).max() ?? 0

        let days = Set(checkIns.map { calendar.startOfDay(for: $0.date) })
        fullWeekends = days.filter { day in
            guard calendar.component(.weekday, from: day) == 7,
                  let sunday = calendar.date(byAdding: .day, value: 1, to: day) else { return false }
            return days.contains(sunday)
        }.count

        let sortedDays = days.sorted()
        comebacks = zip(sortedDays, sortedDays.dropFirst()).filter { previous, next in
            let gap = calendar.dateComponents([.day], from: previous, to: next).day ?? 0
            return gap >= Constants.Badges.comebackGapDays
        }.count
    }

    // MARK: - Functions

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
