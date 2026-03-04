//
//  WorkoutHistoryViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/25/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

// MARK: - ViewModel
extension WorkoutHistoryView {
    class ViewModel: ObservableObject {
        @Published var selectedDay: Date?
        @Published var currMonth = Date.now
        let calendar = Calendar.current
        private let firstWeekday = 2 // calendar always starts on Monday

        private var firstOfCurrMonth: Date {
            calendar.date(from: calendar.dateComponents([.year, .month], from: currMonth))!
        }

        var weeksInMonth: [[Date?]] {
            guard
                let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currMonth))
            else { return [] }

            var days: [Date?] = []

            // Empty weekday slots
            let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
            let leadingWeekdays = (weekdayOfFirst - firstWeekday + 7) % 7
            days.append(contentsOf: Array(repeating: nil, count: leadingWeekdays))

            // Add rest of days in months
            guard let daysInMonth = calendar.range(of: .day, in: .month, for: currMonth) else { return [] }
            for day in daysInMonth {
                days.append(calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth))
            }

            // Empty weekday slots
            while days.count % 7 != 0 {
                days.append(nil)
            }

            return stride(from: 0, to: days.count, by: 7).map { i in
                Array(days[i..<i+7])
            }
        }

        func isSelected(_ date: Date?) -> Bool {
            guard let selectedDay, let date else { return false }
            return date.isSameDay(selectedDay)
        }

        func weekHasSelectedDay(_ week: [Date?]) -> Bool {
            week.contains { isSelected($0) }
        }

        func isSelectedDayOnLeft() -> Bool {
            guard let selectedDay else { return false }
            return selectedDay.getDayOfWeek() == DayOfWeek.monday
        }

        func isSelectedDayOnRight() -> Bool {
            guard let selectedDay else { return false }
            return selectedDay.getDayOfWeek() == DayOfWeek.sunday
        }

        func nextMonth() {
            currMonth = calendar.date(byAdding: .month, value: 1, to: firstOfCurrMonth)!
        }

        func prevMonth() {
            currMonth = calendar.date(byAdding: .month, value: -1, to: firstOfCurrMonth)!
        }
    }
}
