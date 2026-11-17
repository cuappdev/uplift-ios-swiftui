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

    private var interval: ClosedRange<Date> {
        context.attributes.startDate...context.attributes.endDate
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.WorkoutActivity.spacing) {
            header
            progress
        }
        .padding(Constants.WorkoutActivity.padding)
    }

    private var header: some View {
        HStack(spacing: Constants.WorkoutActivity.spacing) {
            icon

            VStack(alignment: .leading, spacing: 2) {
                Text(Constants.WorkoutInProgress.title)
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

            Text(timerInterval: interval, countsDown: false)
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.yellow)
                .monospacedDigit()
                .multilineTextAlignment(.trailing)
                .frame(width: Constants.WorkoutActivity.timerWidth, alignment: .trailing)
        }
    }

    private var icon: some View {
        Image(systemName: "dumbbell.fill")
            .font(Constants.Fonts.h3)
            .foregroundStyle(Constants.Colors.black)
            .frame(width: Constants.WorkoutActivity.iconSize, height: Constants.WorkoutActivity.iconSize)
            .background(Constants.Colors.yellow)
            .clipShape(Circle())
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 6) {
            ProgressView(timerInterval: interval, countsDown: false) {
                EmptyView()
            } currentValueLabel: {
                EmptyView()
            }
            .tint(Constants.Colors.yellow)

            Text("Ends \(context.attributes.endDate.formatted(date: .omitted, time: .shortened))")
                .font(Constants.Fonts.labelNormal)
                .foregroundStyle(Constants.Colors.gray03)
        }
    }

}
