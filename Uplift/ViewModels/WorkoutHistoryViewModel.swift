//
//  WorkoutHistoryViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/25/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import UpliftAPI
import Combine

extension WorkoutHistoryView {

    /// The ViewModel for the Workout history page view.
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedTab: WorkoutHistoryTab = .calendar
        @Published var selectedDay: Date?
        @Published var selectedMonth = Date.now
        @Published var workouts: [Workout?]?
        let calendar = Calendar.current
        private let startOfWeekday = DayOfWeek.monday.rawValue
        private var queryBag = Set<AnyCancellable>()

        /// The first day of the selected month.
        private var firstOfCurrMonth: Date {
            calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        }

        /// A 2D array of dates representing the weeks in the selected month. Each array is 7 elements,
        /// one for each weekday. An entry of `nil` is a placeholder for cells before and after the first
        /// and last day of the month.
        var weeksInMonth: [[Date?]] {
            guard
                let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))
            else { return [] }

            var days: [Date?] = []

            // Empty weekday slots
            let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
            let leadingWeekdays = (weekdayOfFirst - startOfWeekday + 7) % 7
            days.append(contentsOf: Array(repeating: nil, count: leadingWeekdays))

            // Add rest of days in months
            guard let daysInMonth = calendar.range(of: .day, in: .month, for: selectedMonth) else { return [] }
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

        // MARK: - Requests

        func getWorkoutHistory(userId: Int?) {
            guard let userId = userId else {
                Logger.data.critical("WorkoutHistoryViewModel: No userId found")
                return
            }

            Network.client.queryPublisher(
                query: GetWorkoutHistoryQuery(id: userId),
                cachePolicy: .fetchIgnoringCacheData
            )
            .compactMap { $0.data?.getWorkoutsById?.compactMap { $0?.fragments.workoutFields } }
            .map { $0.map { Workout(from: $0) } }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in WorkoutHistoryViewModel.getWorkoutHistory: \(error)")
                }
            } receiveValue: { [weak self] workouts in
                self?.workouts = workouts
            }
            .store(in: &queryBag)
        }

        // MARK: - Helpers

        /// Returns whether the given date is the currently selected day.
        func isSelected(_ date: Date?) -> Bool {
            guard let selectedDay, let date else { return false }
            return date.isSameDay(selectedDay)
        }

        /// Returns whether the given week contains the currently selected day.
        func weekHasSelectedDay(_ week: [Date?]) -> Bool {
            week.contains { isSelected($0) }
        }

        /// Returns whether the selected day is on a Monday (the left edge of the week).
        func isSelectedDayOnLeft() -> Bool {
            guard let selectedDay else { return false }
            return selectedDay.getDayOfWeek() == DayOfWeek.monday
        }

        /// Returns whether the selected day is on a Sunday (the right edge of the week).
        func isSelectedDayOnRight() -> Bool {
            guard let selectedDay else { return false }
            return selectedDay.getDayOfWeek() == DayOfWeek.sunday
        }

        /// Moves the selected month forward by one month.
        func nextMonth() {
            selectedMonth = calendar.date(byAdding: .month, value: 1, to: firstOfCurrMonth)!
        }

        /// Moves the selected month back by one month.
        func prevMonth() {
            selectedMonth = calendar.date(byAdding: .month, value: -1, to: firstOfCurrMonth)!
        }
    }
}
