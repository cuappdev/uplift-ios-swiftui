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

    enum Metric: Hashable {
        case friends
        case gymDays
        case longestStreakWeeks
    }

    // MARK: - Properties

    let friendCount: Int
    let gymDays: Int
    let longestStreakWeeks: Int

    // MARK: - Functions

    func value(for metric: Metric) -> Int {
        switch metric {
        case .friends:
            friendCount
        case .gymDays:
            gymDays
        case .longestStreakWeeks:
            longestStreakWeeks
        }
    }

}
