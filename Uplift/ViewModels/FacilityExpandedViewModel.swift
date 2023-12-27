//
//  FacilityExpandedViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension FacilityExpandedView {

    /// The ViewModel for the expanded facility view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedDay: DayOfWeek = Date.now.getDayOfWeek()
        @Published var selectedHours: [OpenHours] = []
        @Published var isExpanded: Bool = false

        // MARK: - Helpers

        /// Determine selected hours for the selected day.
        func determineHours(facility: Facility) {
            selectedHours = facility.hours.getHoursInDayOfWeek(dayOfWeek: selectedDay)
        }

        /// Determine the text to display beside the hours.
        func getHoursText(hours: OpenHours) -> String? {
            if hours.isWomen ?? false {
                return "women only"
            } else if hours.isShallow ?? false {
                return "shallow only"
            } else if hours.courtType == .basketball {
                return "basketball"
            } else if hours.courtType == .volleyball {
                return "volleyball"
            } else if hours.courtType == .badminton {
                return "badminton"
            } else {
                return nil
            }
        }

    }

}
