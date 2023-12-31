//
//  HomeViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI
import UpliftAPI

extension HomeView {

    /// The ViewModel for the Home page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var gyms: [Gym]?
        @Published var showCapacities: Bool = false

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Requests

        /// Fetch all gyms from the backend.
        func fetchAllGyms() {
            Network.client.queryPublisher(
                query: GetAllGymsQuery(),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .compactMap { $0.data?.gyms?.compactMap(\.?.fragments.gymFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    Logger.data.critical("Error in HomeViewModel.fetchAllGyms: \(error)")
                }
            } receiveValue: { [weak self] gymFields in
                let gyms = [Gym](gymFields)
                self?.gyms = gyms
            }
            .store(in: &queryBag)
        }

        /// Refresh gym data from the backend.
        func refreshGyms() {
            gyms = nil
            fetchAllGyms()
        }

        // MARK: - Helpers

        /**
         The heading text for the navigation bar based on the current time of day.

         * "Good Morning!" if the current hour is from 12 AM to 11AM.
         * "Good Afternoon!" if the current hour is from 12PM to 5PM.
         * "Good Evening!" if the current hour is from 6PM to 11PM.
         */
        var headingText: String {
            let hour = Calendar.current.component(.hour, from: Date.now)
            switch hour {
            case 0..<13:
                return "Good Morning!"
            case 13..<17:
                return "Good Afternoon!"
            default:
                return "Good Evening!"
            }
        }

        /// Calculates the average capacity amount of all fitness centers.
        func calculateAverageCapacity() -> Double {
            let val = gyms?.getAllFitnessCenters()
                .compactMap { facility in
                    switch facility.status {
                    case .open:
                        return facility.capacity?.percent
                    default:
                        return 0
                    }
                }
                .reduce(0, +)
            return val ?? 0.0 / Double(gyms?.getAllFitnessCenters().count ?? 1)
        }

    }

}
