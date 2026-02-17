//
//  Network.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Apollo
import Foundation

/// An API that used Combine Publishers to execute GraphQL requests and return responses via ApolloClient.
final class Network {

    /// The Apollo client.
    static let client: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)

        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = UpliftEnvironment.baseURL
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
