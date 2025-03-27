//
//  MainViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 4/15/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI
import UpliftAPI

extension MainView {

    /// The ViewModel for the Main page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var email: String = ""
        @Published var instagram: String = ""
        @Published var name: String = ""
        @Published var netID: String = ""
        @Published var popUpGiveaway: Bool = false
        @Published var didClickSubmit: Bool = false
        @Published var showCreateProfileView = false
        @Published var showGiveawayErrorAlert: Bool = false
        @Published var showMainView: Bool = false
        @Published var showSignInView: Bool = true
        @Published var submitSuccessful: Bool = false

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Constants

        // TODO: Change hardcoded giveaway ID if needed
        private let giveawayID: Int = 1

        // MARK: - Requests

        /**
         Enter a giveaway.
         */
        func enterGiveaway() {
            createUserRequest(enterGiveawayRequest)
        }

        /**
         Creates a user in the backend.
         */
        func createUser() {
            createUserRequest {
                // TODO: - currently nothing to do after creating user
            }
        }

        /**
         Creates a user in the backend.

         - Parameters:
            - callback: A callback function to be called once the request is done.
         */
        private func createUserRequest(_ callback: @escaping () -> Void) {
            // Make lowercase and remove whitespace
            netID = netID.lowercased().replacingOccurrences(of: " ", with: "")

            // TODO: Update for next giveaway
            Network.client.mutationPublisher(
                mutation: CreateUserMutation(
                    email: self.email,
                    name: self.name,
                    netId: netID
                )
            )
            .compactMap(\.data?.createUser?.netId)
            .sink { completion in
                if case let .failure(error) = completion {
                    callback() // If user already created (error thrown), still enter giveaway
                    Logger.data.critical("Error in MainViewModel.createUserRequest: \(error)")
                }
            } receiveValue: { netID in
                callback()
#if DEBUG
                Logger.data.log("Created a new user with NetID \(netID)")
#endif
            }
            .store(in: &queryBag)
        }

        /// Enters a user to a giveaway in the backend.
        private func enterGiveawayRequest() {
            Network.client.mutationPublisher(
                mutation: EnterGiveawayMutation(giveawayId: giveawayID, userNetId: netID)
            )
            .sink { [weak self] completion in
                guard let self else { return }

                if case let .failure(error) = completion {
                    Logger.data.critical("Error in MainViewModel.enterGiveawayRequest: \(error)")
                    submitSuccessful = false
                    showGiveawayErrorAlert = true
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }

                withAnimation {
                    self.submitSuccessful = true
                }
#if DEBUG
                Logger.data.log("NetID \(netID) has entered giveaway ID \(giveawayID)")
#endif
            }
            .store(in: &queryBag)
        }

    }

}
