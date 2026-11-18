//
//  WorkoutActivityComponents.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import ActivityKit
import SwiftUI
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

struct WorkoutActivityIcon: View {

    // MARK: - Properties

    let phase: WorkoutActivityAttributes.Phase
    var size = Constants.WorkoutActivity.iconSize

    // MARK: - UI

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .padding(size * Constants.WorkoutActivity.iconInset)
            .foregroundStyle(Constants.Colors.black)
            .frame(width: size, height: size)
            .background(Constants.Colors.yellow)
            .clipShape(Circle())
    }

    private var systemName: String {
        switch phase {
        case .active:
            "dumbbell.fill"
        case .finished:
            "checkmark"
        }
    }

}

struct WorkoutActivityTimer: View {

    // MARK: - Properties

    let attributes: WorkoutActivityAttributes
    let phase: WorkoutActivityAttributes.Phase
    var font = Constants.Fonts.h1

    // MARK: - UI

    var body: some View {
        Group {
            switch phase {
            case .active:
                Text(timerInterval: attributes.startDate...attributes.endDate, countsDown: false)
            case .finished(let finishedAt):
                Text(attributes.durationText(finishedAt: finishedAt))
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
