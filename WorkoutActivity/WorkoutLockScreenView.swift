//
//  WorkoutLockScreenView.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct WorkoutLockScreenView: View {

    // MARK: - Properties

    let context: ActivityViewContext<WorkoutActivityAttributes>

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.WorkoutActivity.spacing) {
            header

            if case .active = context.phase {
                WorkoutActivityProgress(attributes: context.attributes)
            }
        }
        .padding(Constants.WorkoutActivity.padding)
    }

    private var header: some View {
        HStack(spacing: Constants.WorkoutActivity.spacing) {
            WorkoutActivityIcon(phase: context.phase)

            WorkoutActivityTitle(gymName: context.attributes.gymName, phase: context.phase)

            Spacer(minLength: 0)

            WorkoutActivityTimer(attributes: context.attributes, phase: context.phase)
                .frame(width: Constants.WorkoutActivity.timerWidth, alignment: .trailing)
        }
    }

}
