//
//  FitnessCenterViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import OSLog
import UpliftAPI
import SwiftUI

extension FitnessCenterView {

    /// The ViewModel for the Fitness Center view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var currentHour: Int = Calendar.current.component(.hour, from: Date())
        @Published var currentHourCapacity: CapacityText = .notBusy
        @Published var daysOfWeek: [String] = []
        @Published var expandHours: Bool = false
        @Published var fitnessCenterHours: [String] = []
        @Published var hourlyCapacities: [HourlyAverageCapacity] = []
        @Published var popularTimesIsAnimating: Bool = false

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Helpers

        /// Fetch a sorted array of strings for fitness center hours.
        func fetchFitnessCenterHours(for fc: Facility) {
            fitnessCenterHours = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                let hours = fc.hours.getHoursInDayOfWeek(dayOfWeek: day).sorted()

                if hours.isEmpty {
                    fitnessCenterHours.append("Closed")
                } else if hours.count > 1 {
                    fitnessCenterHours.append(hours.map { $0.formatOpenCloseHours() }.joined(separator: "\n"))
                } else {
                    fitnessCenterHours.append(hours.first?.formatOpenCloseHours() ?? "")
                }
            }
        }

        /// Fetch a sorted array of strings for days of the week.
        func fetchDaysOfWeek() {
            daysOfWeek = []
            for day in DayOfWeek.sortedDaysOfWeek() {
                if day == Date.now.getDayOfWeek() {
                    daysOfWeek.append("Today")
                } else {
                    daysOfWeek.append(day.dayOfWeekShortened())
                }
            }
        }

        /// Fetch hourly average capacities for a specific facility, filtered by its hours of operation.
        func fetchHourlyAverageCapacities(for fc: Facility) {
            popularTimesIsAnimating = false

            guard let facilityId = Int(fc.id) else {
                Logger.data.critical("Invalid facility ID")
                return
            }

            Network.client.queryPublisher(
                query: GetHourlyAverageCapacitiesByFacilityIdQuery(facilityId: facilityId),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .map { result -> [HourlyAverageCapacity] in
                let hourlyAverage = result.data?.getHourlyAverageCapacitiesByFacilityId ?? []
                let capacities = hourlyAverage.compactMap { cap -> HourlyAverageCapacity? in
                    guard let cap,
                          let dayOfWeek = cap.dayOfWeek?.rawValue else { return nil }

                    if facilityId == cap.facilityId {
                        return HourlyAverageCapacity(
                            averagePercent: cap.averagePercent,
                            dayOfWeek: dayOfWeek,
                            hourOfDay: cap.hourOfDay
                        )
                    }

                    return nil
                }
                return capacities
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in FitnessCenterViewModel.fetchHourlyAverageCapacities: \(error)")
                }
            } receiveValue: { [weak self] (capacities: [HourlyAverageCapacity]) in
                guard let self else { return }

                self.filterCapacities(capacities: capacities, fc: fc)
            }
            .store(in: &queryBag)
        }

        // MARK: - Helper Functions

        private func filterCapacities(capacities: [HourlyAverageCapacity], fc: Facility) {
            let today = Date.now.getDayOfWeek()
            let todayOpenHours = fc.hours.getHoursInDayOfWeek(dayOfWeek: today)

            let calendar = Calendar.current

            let startHour = todayOpenHours.first.map { calendar.component(.hour, from: $0.startTime) } ?? 6
            var endHour = todayOpenHours.last.map { calendar.component(.hour, from: $0.endTime) } ?? 23

            if let endMinutes = todayOpenHours.last.map({ calendar.component(.minute, from: $0.endTime) }), endMinutes > 0 {
                endHour += 1
            }

            let filteredCapacities = capacities.filter { $0.dayOfWeek.capitalized == today.dayOfWeekComplete() }

            let hourRange = startHour...endHour

            var finalHourlyCapacities: [HourlyAverageCapacity] = hourRange.map { hour in
                HourlyAverageCapacity(averagePercent: 0.0, dayOfWeek: "", hourOfDay: hour)
            }

            filteredCapacities.forEach { capacity in
                if hourRange.contains(capacity.hourOfDay) {
                    if let index = finalHourlyCapacities.firstIndex(where: { $0.hourOfDay == capacity.hourOfDay }) {
                        finalHourlyCapacities[index] = capacity
                    }
                }

                if capacity.hourOfDay == currentHour {
                    computeCapacityMessage(percent: capacity.averagePercent)
                }
            }

            self.hourlyCapacities = finalHourlyCapacities

            withAnimation(.easeOut(duration: 0.6)) {
                self.popularTimesIsAnimating = true
            }
        }

        private func computeCapacityMessage(percent: Double) {
            if percent < 0.5 {
                currentHourCapacity = .notBusy
            } else if percent < 0.8 {
                currentHourCapacity = .slightlyBusy
            } else {
                currentHourCapacity = .veryBusy
            }
        }
    }
}
