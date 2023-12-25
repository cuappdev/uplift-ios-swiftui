//
//  HomeViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Combine
import SwiftUI
import UpliftAPI

extension HomeView {

    /// The ViewModel for the Home page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var gyms: [Gym]?

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Requests

        func fetchAllGyms() {
            Network.client.queryPublisher(
                query: GetAllGymsQuery(),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .compactMap { $0.data?.gyms?.compactMap(\.?.fragments.gymFields) }
            .sink { completion in
                if case let .failure(error) = completion {
#if DEBUG
                    print("Error in HomeViewModel.fetchAllGyms: \(error)")
#endif
                }
            } receiveValue: { [weak self] gymFields in
                let gyms = [Gym](gymFields)
                self?.gyms = gyms
            }
            .store(in: &queryBag)
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

    }

}
