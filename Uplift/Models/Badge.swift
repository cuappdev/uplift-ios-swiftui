//
//  Badge.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct Badge: Hashable, Identifiable {

    // MARK: - Types

    enum Art: Hashable {
        case flame(level: Int)
        case gem(level: Int)
        case muscle(MuscleCategory)
        case seal
        case symbol(String)
        case wreath(level: Int)
    }

    enum Category: String, CaseIterable {
        case workouts = "Workouts"
        case streaks = "Streaks"
        case friends = "Friends"
        case strength = "Strength"
        case muscles = "Muscles"
        case special = "Special"
    }

    // MARK: - Properties

    let art: Art
    let category: Category
    let detail: String
    let goal: Int
    let id: String
    let isLegendary: Bool
    let isSecret: Bool
    let metric: BadgeStats.Metric
    let number: Int?
    let title: String

    // MARK: - Init

    init(
        art: Art,
        category: Category,
        detail: String,
        goal: Int,
        id: String,
        isLegendary: Bool = false,
        isSecret: Bool = false,
        metric: BadgeStats.Metric,
        number: Int? = nil,
        title: String
    ) {
        self.art = art
        self.category = category
        self.detail = detail
        self.goal = goal
        self.id = id
        self.isLegendary = isLegendary
        self.isSecret = isSecret
        self.metric = metric
        self.number = number
        self.title = title
    }

    // MARK: - Functions

    func progress(in stats: BadgeStats) -> Int {
        min(stats.value(for: metric), goal)
    }

    func isEarned(in stats: BadgeStats) -> Bool {
        stats.value(for: metric) >= goal
    }

}

// MARK: - Catalog

extension Badge {

    static let all = workouts + streaks + friends + strength + muscles + special

    private static let workouts = [3, 7, 10, 15, 20, 30, 40, 50, 75, 100].map { goal in
        Badge(
            art: .gem(level: goal < 20 ? 1 : goal < 30 ? 2 : goal < 40 ? 3 : 4),
            category: .workouts,
            detail: "Check in at the gym on \(goal) different days.",
            goal: goal,
            id: "workouts-\(goal)",
            isLegendary: goal >= 50,
            metric: .gymDays,
            number: goal,
            title: "\(goal) Workouts"
        )
    }

    private static let streaks = [1, 2, 3, 4, 5, 6, 7, 8, 12, 16, 26].map { weeks in
        let isMonths = weeks >= 8
        let number = isMonths ? weeks / 4 : weeks
        let unit = isMonths ? "Month" : "Week"
        return Badge(
            art: .flame(level: isMonths ? 2 : 1),
            category: .streaks,
            detail: "Hit your weekly goal \(weeks) week\(weeks == 1 ? "" : "s") in a row.",
            goal: weeks,
            id: "streaks-\(weeks)",
            isLegendary: weeks >= 26,
            metric: .longestStreakWeeks,
            number: number,
            title: "\(number) \(unit)\(number == 1 ? "" : "s")"
        )
    }

    private static let friends = [1, 5, 10, 20, 30, 40, 50].map { goal in
        Badge(
            art: .wreath(level: goal < 20 ? 1 : goal < 40 ? 2 : 3),
            category: .friends,
            detail: "Add \(goal) friend\(goal == 1 ? "" : "s") on Uplift.",
            goal: goal,
            id: "friends-\(goal)",
            isLegendary: goal >= 50,
            metric: .friends,
            number: goal,
            title: "\(goal) Friend\(goal == 1 ? "" : "s")"
        )
    }

    private static let strength = [
        Badge(
            art: .symbol("trophy.fill"),
            category: .strength,
            detail: "Set your first personal record.",
            goal: 1,
            id: "strength-first-pr",
            metric: .personalRecordsSet,
            title: "First PR"
        ),
        Badge(
            art: .symbol("bolt.fill"),
            category: .strength,
            detail: "Set \(Constants.Badges.prMachine) personal records.",
            goal: Constants.Badges.prMachine,
            id: "strength-pr-machine",
            metric: .personalRecordsSet,
            title: "PR Machine"
        ),
        Badge(
            art: .symbol("square.stack.3d.up.fill"),
            category: .strength,
            detail: "Log a bench press, squat & deadlift.",
            goal: Constants.Badges.bigThree.count,
            id: "strength-big-three",
            metric: .bigThreeLogged,
            title: "Big Three"
        )
    ] + plateClubs + [
        Badge(
            art: .seal,
            category: .strength,
            detail: "Bench, squat & deadlift a combined \(Constants.Badges.bigThreeClub) lb.",
            goal: Constants.Badges.bigThreeClub,
            id: "strength-1000-club",
            isLegendary: true,
            metric: .bigThreeTotal,
            number: Constants.Badges.bigThreeClub,
            title: "1000 lb Club"
        )
    ]

    private static let plateClubs = [
        (1, Constants.PersonalRecords.onePlate),
        (2, Constants.PersonalRecords.twoPlates),
        (3, Constants.PersonalRecords.threePlates)
    ].map { plates, weight in
        Badge(
            art: .seal,
            category: .strength,
            detail: "Lift \(Int(weight)) lb on any lift.",
            goal: Int(weight),
            id: "strength-plates-\(plates)",
            isLegendary: plates == 3,
            metric: .heaviestLift,
            number: Int(weight),
            title: "\(plates) Plate Club"
        )
    }

    private static let muscles = [
        (MuscleCategory.arm, "Gun Show", "arms"),
        (MuscleCategory.back, "Back Attack", "back"),
        (MuscleCategory.chest, "Chest Day", "chest"),
        (MuscleCategory.shoulder, "Boulder Shoulders", "shoulders")
    ].map { muscle, title, name in
        Badge(
            art: .muscle(muscle),
            category: .muscles,
            detail: "Train \(name) in \(Constants.Badges.muscleVisits) saved workouts.",
            goal: Constants.Badges.muscleVisits,
            id: "muscles-\(name)",
            metric: .muscleDays(muscle),
            title: title
        )
    } + [
        Badge(
            art: .muscle(.leg),
            category: .muscles,
            detail: "Train legs every week for \(Constants.Badges.legDayWeeks) weeks in a row.",
            goal: Constants.Badges.legDayWeeks,
            id: "muscles-leg-day",
            metric: .legDayWeeks,
            title: "Never Skips Leg Day"
        ),
        Badge(
            art: .symbol("figure.strengthtraining.functional"),
            category: .muscles,
            detail: "Train arms, legs, back, chest & shoulders in one week.",
            goal: 1,
            id: "muscles-full-body",
            isLegendary: true,
            metric: .fullBodyWeeks,
            title: "Full Body"
        )
    ]

    private static let special = [
        Badge(
            art: .symbol("crown.fill"),
            category: .special,
            detail: "Joined Uplift during its first semester.",
            goal: 1,
            id: "special-founding",
            isLegendary: true,
            metric: .foundingMember,
            title: "Founding Member"
        ),
        Badge(
            art: .symbol("map.fill"),
            category: .special,
            detail: "Check in at all \(Constants.Badges.gymCount) campus gyms.",
            goal: Constants.Badges.gymCount,
            id: "special-explorer",
            metric: .gymsVisited,
            title: "Gym Explorer"
        ),
        Badge(
            art: .symbol("house.fill"),
            category: .special,
            detail: "Check in at the same gym \(Constants.Badges.regularVisits) times.",
            goal: Constants.Badges.regularVisits,
            id: "special-regular",
            metric: .topGymVisits,
            title: "Regular"
        ),
        Badge(
            art: .symbol("sunrise.fill"),
            category: .special,
            detail: "Check in before \(Constants.Badges.earlyCheckInHour) AM.",
            goal: 1,
            id: "special-early-bird",
            isSecret: true,
            metric: .earlyCheckIns,
            title: "Early Bird"
        ),
        Badge(
            art: .symbol("moon.stars.fill"),
            category: .special,
            detail: "Check in after \(Constants.Badges.lateCheckInHour - 12) PM.",
            goal: 1,
            id: "special-night-owl",
            isSecret: true,
            metric: .lateCheckIns,
            title: "Night Owl"
        ),
        Badge(
            art: .symbol("figure.strengthtraining.traditional"),
            category: .special,
            detail: "Check in on a Saturday and the Sunday after it.",
            goal: 1,
            id: "special-weekend-warrior",
            isSecret: true,
            metric: .fullWeekends,
            title: "Weekend Warrior"
        ),
        Badge(
            art: .symbol("arrow.uturn.up"),
            category: .special,
            detail: "Come back to the gym after \(Constants.Badges.comebackGapDays) days away.",
            goal: 1,
            id: "special-comeback",
            isSecret: true,
            metric: .comebacks,
            title: "Comeback"
        )
    ]

}
