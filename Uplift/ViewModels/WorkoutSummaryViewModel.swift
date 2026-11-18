//
//  WorkoutSummaryViewModel.swift
//  Uplift
//
//  Created by Kaylee Ulep on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Combine

extension WorkoutSummaryView {
    @MainActor
    class ViewModel: ObservableObject {
        enum Mode {
            case create
            case edit
        }

        @Published var isEditing: Bool
        @Published var title: String
        @Published var description: String
        @Published var muscleGroups: [String]
        @Published var satisfaction: Double

        let summary: WorkoutSummary
        let mode: Mode

        init(summary: WorkoutSummary, mode: Mode) {
            self.summary = summary
            self.mode = mode

            self.isEditing = mode == .create
            self.title = summary.title
            self.description = summary.description
            self.muscleGroups = summary.muscleGroups
            self.satisfaction = summary.satisfaction
        }

        func makeWorkoutSummary() -> WorkoutSummary {
            var updatedSummary = summary
            updatedSummary.title = title
            updatedSummary.description = description
            updatedSummary.muscleGroups = muscleGroups
            updatedSummary.satisfaction = satisfaction

            return updatedSummary
        }

        func saveWorkout() {
            let updatedSummary = makeWorkoutSummary()

            switch mode {
            case .create:
                // TODO: Backend create workout mutation
                break

            case .edit:
                // TODO: Backend update workout mutation
                break
            }

            // TODO: Handle loading, success, and error states.
            // Only exit editing mode after a successful save.
        }
    }
}
