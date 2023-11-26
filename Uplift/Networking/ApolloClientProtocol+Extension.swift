//
//  ApolloClientProtocol+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Apollo

extension ApolloClientProtocol {

//    /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
//    ///
//    /// - Parameters:
//    ///   - query: The query to fetch.
//    ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache. Defaults to ``.default`.
//    ///   - contextIdentifier: [optional] A unique identifier for this request, to help with deduping cache hits for watchers. Defaults to `nil`.
//    ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
//    ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
//    /// - Returns: A publisher that delivers results from the fetch operation.
//    func fetchPublisher<Query: GraphQLQuery>(query: Query,
//                                             cachePolicy: CachePolicy = .default,
//                                             contextIdentifier: UUID? = nil,
//                                             context: RequestContext? = nil,
//                                             queue: DispatchQueue = .main) -> Publishers.ApolloFetch<Query> {
//        let config = Publishers.ApolloFetchConfiguration(client: self,
//                                                         query: query,
//                                                         cachePolicy: cachePolicy,
//                                                         contextIdentifier: contextIdentifier,
//                                                         context: context,
//                                                         queue: queue)
//        return Publishers.ApolloFetch(with: config)
//    }
//
//    func queryPublisher<Query: GraphQLQuery>(
//        query: Query,
//        cachePolicy: CachePolicy = .default,
//        contextIdentifier: UUID? = nil,
//        context: RequestContext? = nil,
//        queue: DispatchQueue = .main
//    ) -> {
//        let config = Publishers.ApolloFetchConfiguration(
//            client: self,
//            query: query,
//            cachePolicy: cachePolicy,
//            contextIdentifier: contextIdentifier,
//            context: context,
//            queue: queue
//        )
//    }

}
