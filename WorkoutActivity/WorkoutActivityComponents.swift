//
//  WorkoutActivityComponents.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WorkoutActivityIcon: View {

    // MARK: - Properties

    var isFinished = false
    var size = Constants.WorkoutActivity.iconSize

    // MARK: - UI

    var body: some View {
        Image(systemName: isFinished ? "checkmark" : "dumbbell.fill")
            .resizable()
            .scaledToFit()
            .padding(size * Constants.WorkoutActivity.iconInset)
            .foregroundStyle(Constants.Colors.black)
            .frame(width: size, height: size)
            .background(Constants.Colors.yellow)
            .clipShape(Circle())
    }

}

struct WorkoutActivityTimer: View {

    // MARK: - Properties

    let attributes: WorkoutActivityAttributes
    let state: WorkoutActivityAttributes.ContentState
    var font = Constants.Fonts.h1

    // MARK: - UI

    var body: some View {
        Group {
            if let finishedAt = state.finishedAt {
                Text(attributes.durationText(finishedAt: finishedAt))
            } else {
                Text(timerInterval: attributes.startDate...attributes.endDate, countsDown: false)
            }
        }
        .font(font)
            .foregroundStyle(Constants.Colors.yellow)
            .monospacedDigit()
            .multilineTextAlignment(.trailing)
    }

}

struct WorkoutActivityProgress: View {

    // MARK: - Properties

    let attributes: WorkoutActivityAttributes

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.WorkoutActivity.progressSpacing) {
            ProgressView(timerInterval: attributes.startDate...attributes.endDate, countsDown: false) {
                EmptyView()
            } currentValueLabel: {
                EmptyView()
            }
            .tint(Constants.Colors.yellow)

            Text("Ends \(attributes.endDate.formatted(date: .omitted, time: .shortened))")
                .font(Constants.Fonts.labelNormal)
                .foregroundStyle(Constants.Colors.gray03)
        }
    }

}
