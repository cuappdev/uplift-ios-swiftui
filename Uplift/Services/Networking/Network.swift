//
//  Network.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Apollo
import Foundation

/// An API that used Combine Publishers to execute GraphQL requests and return responses via ApolloClient.
final class Network {

    /// The Apollo client.
    static let client = ApolloClient(url: Environment.baseURL)

}
