//
//  WorkoutActivityAttributes.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct WorkoutActivityAttributes: ActivityAttributes {

    // MARK: - Types

    struct ContentState: Codable, Hashable {
        var finishedAt: Date?
    }

    // MARK: - Properties

    let endDate: Date
    let gymName: String?
    let startDate: Date

    // MARK: - Functions

    func durationText(finishedAt: Date) -> String {
        let seconds = Int(max(0, min(finishedAt, endDate).timeIntervalSince(startDate)))
        let hours = seconds / 3600
        let minutes = seconds % 3600 / 60
        return hours > 0 ? "\(hours) h \(minutes) min" : "\(minutes) min"
    }

}
