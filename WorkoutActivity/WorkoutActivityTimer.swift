//
//  WorkoutActivityTimer.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

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
