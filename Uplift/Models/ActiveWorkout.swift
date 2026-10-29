//
//  ActiveWorkout.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/29/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct ActiveWorkout: Codable, Hashable {

    // MARK: - Properties

    let autoEndDate: Date
    let gymName: String?
    let startDate: Date
    let workoutId: String?

    // MARK: - Functions

    init(gymName: String?, closeTime: Date?, workoutId: String?, startDate: Date = .now) {
        let maxEndDate = startDate.addingTimeInterval(Constants.WorkoutInProgress.maxDuration)
        let endDate = closeTime ?? maxEndDate
        self.autoEndDate = endDate > startDate ? min(endDate, maxEndDate) : maxEndDate
        self.gymName = gymName
        self.startDate = startDate
        self.workoutId = workoutId
    }

    func elapsed(at now: Date) -> TimeInterval {
        max(0, min(now, autoEndDate).timeIntervalSince(startDate))
    }

    func isFinished(at now: Date) -> Bool {
        now >= autoEndDate
    }

}
