//
//  WorkoutActivityManager.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import OSLog

protocol WorkoutActivityManaging {
    func start(_ workout: ActiveWorkout)
    func finish(at date: Date)
    func cancel()
}

final class WorkoutActivityManager: WorkoutActivityManaging {

    // MARK: - Properties

    static let shared = WorkoutActivityManager()

    private init() {}

    // MARK: - Functions

    func start(_ workout: ActiveWorkout) {
        guard #available(iOS 16.2, *), ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        for activity in Activity<WorkoutActivityAttributes>.activities {
            Task {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }

        do {
            _ = try Activity.request(
                attributes: WorkoutActivityAttributes(
                    endDate: workout.autoEndDate,
                    gymName: workout.gymName,
                    startDate: workout.startDate
                ),
                content: ActivityContent(state: .init(), staleDate: workout.autoEndDate),
                pushType: nil
            )
        } catch {
            Logger.services.error("Error in WorkoutActivityManager.start: \(error.localizedDescription)")
        }
    }

    func finish(at date: Date) {
        guard #available(iOS 16.2, *) else { return }

        let content = ActivityContent(state: WorkoutActivityAttributes.ContentState(finishedAt: date), staleDate: nil)
        let dismissal = Date.now.addingTimeInterval(Constants.WorkoutInProgress.activityLingerDuration)
        for activity in Activity<WorkoutActivityAttributes>.activities {
            Task {
                await activity.end(content, dismissalPolicy: .after(dismissal))
            }
        }
    }

    func cancel() {
        guard #available(iOS 16.2, *) else { return }

        // finished activities are left to linger so the complete state stays visible
        let activities = Activity<WorkoutActivityAttributes>.activities
        for activity in activities where activity.content.state.finishedAt == nil {
            Task {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }

}
