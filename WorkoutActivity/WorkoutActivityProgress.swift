//
//  WorkoutActivityProgress.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

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
