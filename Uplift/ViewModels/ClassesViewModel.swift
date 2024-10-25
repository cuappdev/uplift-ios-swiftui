//
//  ClassesViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/13/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI
import Combine
import OSLog

extension ClassesView {

    /// The ViewModel for the Classes page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var classes: [FitnessClassInstance]?
        @Published var selectedDay: DayOfWeek = Date.now.getDayOfWeek()
        @Published var weeksFromCurr: Int = 0    // e.g. 1 for next week

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Requests

        /// Fetch all classes from the backend.
        func fetchAllClasses() {
            Network.client.queryPublisher(
                query: GetAllGymsQuery(),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .compactMap { $0.data?.gyms?.compactMap(\.?.fragments.gymFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in ClassesViewModel.fetchAllClasses: \(error)")
                }
            } receiveValue: { [weak self] gymFields in
                guard let self else { return }

                let gyms: [Gym] = gymFields.map { Gym(from: $0) }
                let classes: [FitnessClassInstance] = gyms.flatMap { $0.classes }

                self.classes = classes
            }
            .store(in: &queryBag)
        }

        /// Refresh classes data from the backend.
        func refreshClasses() {
            classes = nil
            fetchAllClasses()
        }

        // MARK: - Helpers

        /// The filtered array of classes occurring on the selected day.
        var filteredClasses: [FitnessClassInstance] {
            guard let classes = classes,
                  let selectedDate = determineDayOfMonth(selectedDay, weeksFromCurr) else { return [] }

            return classes
                .filter { toDate($0.startTime)?.isSameDay(selectedDate) == true }
                .sorted {
                    guard let lhsDate = toDate($0.startTime),
                          let rhsDate = toDate($1.startTime) else { return false }
                    return lhsDate < rhsDate
                }
        }

        /// The array of next sessions for this class.
        func nextSessions(classInstance: FitnessClassInstance) -> [FitnessClassInstance] {
            guard let classes = classes,
                  let selectedDate = toDate(classInstance.startTime) else { return [] }

            return classes
                .filter {
                    if let date = toDate($0.startTime) {
                        return date > selectedDate && $0.classId == classInstance.classId
                    }
                    return false
                }
                .sorted {
                    guard let lhsDate = toDate($0.startTime),
                          let rhsDate = toDate($1.startTime) else { return false }
                    return lhsDate < rhsDate
                }
        }

        /// Determine the day of the month for the given weekday. `Nil` if the calendar date is invalid.
        func determineDayOfMonth(_ weekday: DayOfWeek, _ weeksFromCurr: Int) -> Date? {
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
            return Calendar.current.date(byAdding: .day, value: weekdayValue + (7 * weeksFromCurr), to: .now)
        }

        /// Convert a string to a `Date` object. `nil` if `string` is not in the ISO8601 format.
        func toDate(_ string: String?) -> Date? {
            guard let string = string else { return nil }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return dateFormatter.date(from: string)
        }

        /// Determine the duration of time in minutes between the given start and end time. `nil` if input strings are invalid formats.
        func determineDuration(_ startTime: String?, _ endTime: String?) -> String? {
            guard let startTime = toDate(startTime),
                  let endTime = toDate(endTime) else { return nil }

            let interval = endTime.timeIntervalSince(startTime)
            return String(Int(interval / 60))
        }

        /// Determines whether any classes occur on the given weekday during the displayed week.
        func hasClasses(weekday: DayOfWeek) -> Bool {
            guard let classes = classes,
                  let thisDate = determineDayOfMonth(weekday, weeksFromCurr) else { return false }

            return classes.contains {
                if let date = toDate($0.startTime) {
                    return date.isSameDay(thisDate)
                }
                return false
            }
        }

    }
}
