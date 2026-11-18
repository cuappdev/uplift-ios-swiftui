//
//  WorkoutSummary.swift
//  Uplift
//
//  Created by Kaylee Ulep on 11/11/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Align this model with the backend Workout model once
// workout summary fields are supported. Determine whether
// WorkoutSummary should remain a separate form model or be
// replaced by the updated Workout model.
struct WorkoutSummary: Identifiable, Codable {
    let id: UUID
    let gymName: String?
    let startDate: Date
    let endDate: Date

    var title: String
    var description: String
    var muscleGroups: [String]
    var satisfaction: Double

}

extension WorkoutSummary {
    init(activeWorkout: ActiveWorkout, endDate: Date) {
        self.init(
            id: UUID(),
            gymName: activeWorkout.gymName,
            startDate: activeWorkout.startDate,
            endDate: endDate,
            title: "",
            description: "",
            muscleGroups: [],
            satisfaction: 0
        )
    }
}
