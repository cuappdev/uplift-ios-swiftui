//
//  NetworkManager.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Apollo
import Combine
import Foundation
import UpliftAPI

/// An API that creates Combine Publishers that execute GraphQL requests and return responses via ApolloClient.
class NetworkManager {

    // MARK: - Properties

    /// Shared singleton instance of `NetworkManager`.
    static let shared = NetworkManager()

    /// The Apollo client.
    private let client = ApolloClient(url: Environment.baseURL)

    // MARK: - Requests

}
