//
//  ReportViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import Combine
import UpliftAPI

extension ReportView {

    /// The ViewModel for the Report page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var description = ""
        @Published var gyms: [Gym]?
        @Published var selectedGym = ""
        @Published var selectedIssue = ""
        @Published var submitSuccessful = false

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
                    Logger.data.critical("Error in ReportViewModel.fetchAllGyms: \(error)")
                }
            } receiveValue: { [weak self] gymFields in
                guard let self else { return }

                gyms = [Gym](gymFields)
            }
            .store(in: &queryBag)
        }

        /// Creates a report in the backend.
        func createReport() {
            let gymId = gymIdWithName(selectedGym)

            Network.client.mutationPublisher(
                mutation: CreateReportMutation(
                    createdAt: Date.now.ISO8601Format(),
                    description: description,
                    gymId: gymId,
                    issue: selectedIssue,
                    userId: 0
                )
            )
            .sink { [weak self] completion in
                guard self != nil else { return }

                if case let .failure(error) = completion {
                    Logger.data.critical("Error in ReportViewModel.createReport: \(error)")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }

                self.submitSuccessful = true
            }
            .store(in: &queryBag)
        }

        // MARK: - Helpers

        /// Retrieves the ID of the gym with this name.
        private func gymIdWithName(_ name: String) -> Int {
            let gym = gyms?.first { $0.name == name }

            guard let gym else { return 0 }
            return Int(gym.id) ?? 0
        }

    }
}
