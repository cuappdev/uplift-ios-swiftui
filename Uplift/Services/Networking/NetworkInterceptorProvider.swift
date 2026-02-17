//
//  NetworkInterceptorProvider.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/9/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Apollo
import ApolloAPI

class NetworkInterceptorProvider: DefaultInterceptorProvider {

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }

}
