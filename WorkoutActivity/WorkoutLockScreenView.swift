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

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.white)

                if let gymName = context.attributes.gymName {
                    Text(gymName)
                        .font(Constants.Fonts.labelNormal)
                        .foregroundStyle(Constants.Colors.gray02)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            WorkoutActivityTimer(attributes: context.attributes, phase: context.phase)
                .frame(width: Constants.WorkoutActivity.timerWidth, alignment: .trailing)
        }
    }

    private var title: String {
        switch context.phase {
        case .active:
            Constants.WorkoutInProgress.title
        case .finished:
            Constants.WorkoutActivity.finishedTitle
        }
    }

}
