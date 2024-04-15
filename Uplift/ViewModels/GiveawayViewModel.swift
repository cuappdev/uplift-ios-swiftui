//
//  GiveawayViewModel.swift
//  Uplift
//
//  Created by Belle Hu on 4/14/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Combine
import OSLog
import SwiftUI
import UpliftAPI

extension GiveawayPopup {

    /// The ViewModel for Giveaway popup.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()

        // MARK: - Requests

        /// Creates a user.
        func createUser(_ netId: String) async {
            Network.client.mutationPublisher(mutation: UpliftAPI.CreateUserMutation(netId: netId))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(completion)
                } receiveValue: { _ in
#if DEBUG
                    Logger.services.log("Created user: \(netId)")
#endif
                }
                .store(in: &queryBag)
        }

        /// Creates a giveaway.
        func createGiveaway(_ name: String) async {
            Network.client.mutationPublisher(mutation: UpliftAPI.CreateGiveawayMutation(name: name))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(completion)
                } receiveValue: { _ in
#if DEBUG
                    Logger.services.log("Created giveaway: \(name)")
#endif
                }
                .store(in: &queryBag)
        }

        /// Enters a user into a giveaway.
        func enterGiveaway(_ giveawayId: Int, _ userNetId: String) async {
            Network.client.mutationPublisher(mutation: UpliftAPI.EnterGiveawayMutation(giveawayId: giveawayId, userNetId: userNetId))
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(completion)
                } receiveValue: { _ in
#if DEBUG
                    Logger.services.log("Entered user, \(userNetId), into giveaway \(giveawayId)")
#endif
                }
                .store(in: &queryBag)
        }

    }

}
