//
//  ClassesViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/13/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension ClassesView {

    /// The ViewModel for the Classes page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedDay: DayOfWeek = Date.now.getDayOfWeek()

        // MARK: - Helpers

        /// Determine the day of the month for the given weekday.
        func determineDayOfMonth(weekday: DayOfWeek) -> String {
            var weekdayValue = 0
            if weekday != Date.now.getDayOfWeek() {
                weekdayValue = switch weekday {
                case .sunday:
                    // Modified Sunday so that it's calculated as the last day of the week
                    DayOfWeek.saturday.rawValue + 1 - Date.now.getDayOfWeek().rawValue
                default:
                    weekday.rawValue - Date.now.getDayOfWeek().rawValue
                }
            }
            return Calendar.current.date(byAdding: .day, value: weekdayValue, to: .now)?.formatted(.dateTime.day()) ?? ""
        }

    }
}
