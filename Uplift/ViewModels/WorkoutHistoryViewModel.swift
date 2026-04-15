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
        @Published var workouts: [Workout]?
        let calendar = Calendar.current
        private let startOfWeek = DayOfWeek.monday.rawValue
        private var queryBag = Set<AnyCancellable>()

        /// The first day of the selected month.
        private var firstOfCurrMonth: Date {
            calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        }

        /// Returns the list of workouts in the tuple `(Workout, Date)` sorted by newest workout first.
        private var workoutsWithDates: [(Workout, Date)] {
            guard let workouts else { return [] }

            let sortedWorkouts = workouts
                .compactMap { workout -> (Workout, Date)? in
                    guard let date = WorkoutTimeFormatter.isoToDate(workout.workoutTime) else { return nil }
                    return (workout, date)  // allow sorting by date
                }
                .sorted { $0.1 > $1.1 } // sort by newest first

            return sortedWorkouts
        }

        /// Workouts grouped by day (start of day) in ascending calendar day order.
        private var workoutsByStartOfDay: [Date: [Workout]] {
            var workoutDays: [Date: [Workout]] = [:]
            for (workout, date) in workoutsWithDates {
                let startOfDay = calendar.startOfDay(for: date)
                workoutDays[startOfDay, default: []].append(workout)
            }
            return workoutDays
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
            let leadingWeekdays = (weekdayOfFirst - startOfWeek + 7) % 7
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

        /// Returns the workout on the selected day. Currently there can only be one workout logged per day
        /// (change if this is no longer the case).
        var selectedWorkout: Workout? {
            guard let day = selectedDay else { return nil }
            return workoutsByStartOfDay[calendar.startOfDay(for: day)]?.first
        }

        /// An array of sections that groups `workouts` into months. Each section contains the
        /// sorted workouts in that month.
        var workoutMonthSections: [WorkoutMonthSection] {
                        let titleFormatter = DateFormatter()
            titleFormatter.locale = Locale(identifier: "en_US_POSIX")
            titleFormatter.timeZone = calendar.timeZone
            titleFormatter.dateFormat = "MMMM yyyy" // March 2026

            var sections: [WorkoutMonthSection] = []
            for (workout, date) in workoutsWithDates {
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let id = String(format: "%04d-%02d", year, month)

                guard let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
                    continue
                }

                let title = titleFormatter.string(from: firstOfMonth)
                if var prevMonth = sections.last, prevMonth.id == id {
                    sections.removeLast()
                    prevMonth.workouts.append(workout)
                    sections.append(prevMonth)
                } else {
                    sections.append(WorkoutMonthSection(id: id, title: title, workouts: [workout]))
                }
            }

            return sections
        }

        // MARK: - Helper Structs

        struct WorkoutMonthSection: Identifiable {
            let id: String  // e.g. "2026-03"
            let title: String   // e.g. "March 2026"
            var workouts: [Workout]
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

        /// Returns whether there is a workout logged on this day.
        func hasWorkout(on day: Date) -> Bool {
            workoutsByStartOfDay.keys.contains(calendar.startOfDay(for: day))
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

        // TODO: Remove later
        func logWorkout(
            facilityId: Int,
            userId: Int,
            workoutTime: Date = .now,
            completion: ((Result<Void, Error>) -> Void)? = nil
        ) {
            Network.client.mutationPublisher(
                mutation: LogWorkoutMutation(
                    facilityId: facilityId,
                    userId: userId,
                    workoutTime: workoutTime.ISO8601Format()
                )
            )
            .compactMap(\.data?.logWorkout)
            .sink { completionResult in
                if case let .failure(error) = completionResult {
                    Logger.data.critical("Error in WorkoutHistoryViewModel.logWorkout: \(error)")
                    completion?(.failure(error))
                }
            } receiveValue: { _ in
                completion?(.success(()))
            }
            .store(in: &queryBag)
        }
    }
}
