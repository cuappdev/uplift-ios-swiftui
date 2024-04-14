//
//  Network.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Apollo
import Combine
import Foundation
import OSLog

/// An API that used Combine Publishers to execute GraphQL requests and return responses via ApolloClient.
final class Network {

    /// The Apollo client.
    static let client = ApolloClient(url: UpliftEnvironment.baseURL)

}

class NetworkState: ObservableObject {

    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            Logger.services.critical("Error")
        }
    }
}

