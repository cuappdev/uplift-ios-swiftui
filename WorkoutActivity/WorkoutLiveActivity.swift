//
//  WorkoutLiveActivity.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import SwiftUI
import WidgetKit

@main
struct WorkoutLiveActivity: Widget {

    // MARK: - UI

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutActivityAttributes.self) { context in
            WorkoutLockScreenView(context: context)
                .activityBackgroundTint(Constants.Colors.black)
                .activitySystemActionForegroundColor(Constants.Colors.yellow)
        } dynamicIsland: { context in
            WorkoutDynamicIsland(context: context).island
        }
    }

}
