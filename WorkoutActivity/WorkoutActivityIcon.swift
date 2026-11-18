//
//  WorkoutActivityIcon.swift
//  WorkoutActivity
//
//  Created by Anatoli Monsalve on 11/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

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
