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
        case symbol(String)
        case wreath(level: Int)
    }

    enum Category: String, CaseIterable {
        case workouts = "Workouts"
        case streaks = "Streaks"
        case friends = "Friends"
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

    static let all = workouts + streaks + friends

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

}
