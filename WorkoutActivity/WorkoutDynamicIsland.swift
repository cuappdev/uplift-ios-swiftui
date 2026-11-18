//
//  WorkoutDynamicIsland.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct WorkoutDynamicIsland {

    // MARK: - Properties

    let context: ActivityViewContext<WorkoutActivityAttributes>

    // MARK: - UI

    var island: DynamicIsland {
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                WorkoutActivityIcon(phase: context.phase)
            }

            DynamicIslandExpandedRegion(.center) {
                WorkoutActivityTitle(gymName: context.attributes.gymName, phase: context.phase)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            DynamicIslandExpandedRegion(.trailing) {
                WorkoutActivityTimer(attributes: context.attributes, phase: context.phase)
                    .frame(width: Constants.WorkoutActivity.timerWidth, alignment: .trailing)
            }

            DynamicIslandExpandedRegion(.bottom) {
                if case .active = context.phase {
                    WorkoutActivityProgress(attributes: context.attributes)
                }
            }
        } compactLeading: {
            WorkoutActivityIcon(phase: context.phase, size: Constants.WorkoutActivity.compactIconSize)
        } compactTrailing: {
            WorkoutActivityTimer(attributes: context.attributes, phase: context.phase, font: Constants.Fonts.h4)
                .frame(width: Constants.WorkoutActivity.compactTimerWidth)
        } minimal: {
            WorkoutActivityIcon(phase: context.phase, size: Constants.WorkoutActivity.compactIconSize)
        }
        .keylineTint(Constants.Colors.yellow)
    }

}
