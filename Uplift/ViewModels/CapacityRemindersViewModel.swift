//
//  CapacityRemindersViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/27/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation

extension CapacityRemindersView {

    /// The ViewModel for the Classes page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedDays: [DayOfWeek] = []
        @Published var selectedLocations: [String] = []

    }
}
