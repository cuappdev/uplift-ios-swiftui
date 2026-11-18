//
//  WorkoutActivityTitle.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WorkoutActivityTitle: View {

    // MARK: - Properties

    let gymName: String?
    let phase: WorkoutActivityAttributes.Phase

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.WorkoutActivity.titleSpacing) {
            Text(title)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.white)

            if let gymName {
                Text(gymName)
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(Constants.Colors.gray02)
            }
        }
        .lineLimit(1)
    }

    private var title: String {
        switch phase {
        case .active:
            Constants.WorkoutInProgress.title
        case .finished:
            Constants.WorkoutActivity.finishedTitle
        }
    }

}
