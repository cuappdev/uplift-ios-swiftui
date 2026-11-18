//
//  ActivityViewContext+Extension.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import WidgetKit

extension ActivityViewContext where Attributes == WorkoutActivityAttributes {

    // the app can't update the activity when the workout auto ends in the background, so a stale one is finished
    var phase: WorkoutActivityAttributes.Phase {
        if let finishedAt = state.finishedAt {
            return .finished(at: finishedAt)
        }
        return isStale ? .finished(at: attributes.endDate) : .active
    }

}
