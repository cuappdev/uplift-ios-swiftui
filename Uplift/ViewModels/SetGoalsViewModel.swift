//
//  SetGoalsViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension SetGoalsView {

    /// The ViewModel for the Set Goals page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedDays: [DayOfWeek] = []

        // MARK: - Helpers

        func setEveryDay(_ isEveryDay: Bool) {
            selectedDays = isEveryDay ? DayOfWeek.sortedDaysOfWeek() : []
        }

    }
}
