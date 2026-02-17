//
//  AuthorizationInterceptor.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/9/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Apollo
import ApolloAPI
import OSLog

class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation: GraphQLOperation {
        let isRefresh = Operation.operationName == "RefreshAccessToken"
        if !isRefresh {
            if let token = UserSessionManager.shared.accessToken {
                request.addHeader(name: "Authorization", value: "Bearer \(token)")
            }
        } else {
            if let token = UserSessionManager.shared.refreshToken {
                request.addHeader(name: "Authorization", value: "Bearer \(token)")
            }
        }

        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                // Request fails with no GraphQL payload
                if self.isTokenExpiredError(error) {
                    self.refreshTokenAndRetry(chain: chain, request: request, completion: completion)
                } else {
                    completion(result)
                }
            case .success(let graphQLResult):
                // Parsing succeeds, still possible to have a GraphQL-level error
                if let firstError = graphQLResult.errors?.first,
                   firstError.localizedDescription.lowercased().contains("signature has expired") {
                    self.refreshTokenAndRetry(chain: chain, request: request, completion: completion)
                    return
                }
                completion(result)
            }
        }
    }

    /// Returns whether the token throws an error that is has expired.
    private func isTokenExpiredError(_ error: Error) -> Bool {
        if let wrapper = error as? GraphQLErrorWrapper {
            let msg = wrapper.msg.lowercased()
            return msg.contains("signature has expired")
        }
        return false
    }

    /// If token has expired, refreshes the token and runs the network request again.
    private func refreshTokenAndRetry<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation: GraphQLOperation {
        UserSessionManager.shared.refreshAccessToken { refreshResult in
            switch refreshResult {
            case .success:
                chain.retry(request: request, completion: completion)
            case .failure(let refreshError):
                completion(.failure(refreshError))
            }
        }
    }

}
