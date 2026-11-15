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

}
