//
//  FriendProfile.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

struct FriendProfile: Hashable {

    // MARK: - Properties

    let activeStreak: Int
    let checkIns: [BadgeStats.CheckIn]
    let friend: Friend
    let friendCount: Int
    let gymDays: Int
    let maxStreak: Int
    let workoutGoal: Int?

    // MARK: - Init

    init(from user: GetFriendProfileQuery.Data.GetUserByNetId) {
        activeStreak = user.activeStreak
        checkIns = user.workoutHistory?.compactMap { workout in
            guard let workout, let date = Foundation.Date.fromBackend(workout.workoutTime) else { return nil }
            return BadgeStats.CheckIn(date: date, gymName: workout.gymName)
        } ?? []
        friend = Friend(from: user.fragments.friendFields)
        friendCount = user.friends?.compactMap { $0 }.count ?? 0
        gymDays = user.totalGymDays
        maxStreak = user.maxStreak
        workoutGoal = user.workoutGoal
    }

    init(
        activeStreak: Int,
        checkIns: [BadgeStats.CheckIn],
        friend: Friend,
        friendCount: Int,
        gymDays: Int,
        maxStreak: Int,
        workoutGoal: Int?
    ) {
        self.activeStreak = activeStreak
        self.checkIns = checkIns
        self.friend = friend
        self.friendCount = friendCount
        self.gymDays = gymDays
        self.maxStreak = maxStreak
        self.workoutGoal = workoutGoal
    }

    // MARK: - Computed Properties

    var badgeStats: BadgeStats {
        BadgeStats(friendCount: friendCount, gymDays: gymDays, longestStreakWeeks: maxStreak, checkIns: checkIns)
    }

    // MARK: - Functions

    func daysThisWeek(now: Foundation.Date = .now, calendar: Calendar = .current) -> Int {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else { return 0 }
        return Set(checkIns.filter { week.contains($0.date) }.map { calendar.startOfDay(for: $0.date) }).count
    }

}
