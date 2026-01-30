//
//  UserSessionManager.swift
//  Uplift
//
//  Created by Richie Sun on 4/27/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn
import os
import SwiftUI
import UpliftAPI

enum SessionRestoreResult {
    case success
    case needsSignIn
    case needsProfileCreation
    case error(String)
}

class UserSessionManager: ObservableObject {

    // MARK: - Singleton Instance

    static let shared = UserSessionManager()

    // MARK: - Properties

    private var queryBag = Set<AnyCancellable>()

    @Published var netID: String? {
        didSet {
            if let netID {
                KeychainManager.shared.save(netID, forKey: "netID")
            } else {
                KeychainManager.shared.delete(forKey: "netID")
            }
        }
    }

    @Published var accessToken: String? {
        didSet {
            if let accessToken {
                KeychainManager.shared.save(accessToken, forKey: "accessToken")
            } else {
                KeychainManager.shared.delete(forKey: "accessToken")
            }
        }
    }

    @Published var refreshToken: String? {
        didSet {
            if let refreshToken {
                KeychainManager.shared.save(refreshToken, forKey: "refreshToken")
            } else {
                KeychainManager.shared.delete(forKey: "refreshToken")
            }
        }
    }

    @Published var email: String? {
        didSet {
            if let email {
                KeychainManager.shared.save(email, forKey: "email")
            } else {
                KeychainManager.shared.delete(forKey: "email")
            }
        }
    }

    // MARK: - Init

    private init() {
        self.netID = KeychainManager.shared.get(forKey: "netID")
        self.accessToken = KeychainManager.shared.get(forKey: "accessToken")
        self.refreshToken = KeychainManager.shared.get(forKey: "refreshToken")
        self.email = KeychainManager.shared.get(forKey: "email")
    }

    // MARK: - User Session Functions

    /// Logs out the current user by clearing all session data and tokens.
    func logout() {
        netID = nil
        accessToken = nil
        refreshToken = nil
    }

    /// Logs in a user by sending a login mutation and storing the returned access and refresh tokens.
    func loginUser(netId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Network.client.mutationPublisher(
            mutation: LoginUserMutation(netId: netId),
            publishResultToStore: false,
            queue: .main
        )
        .map { result -> (accessToken: String, refreshToken: String)? in
            guard let loginUser = result.data?.loginUser,
                  let accessToken = loginUser.accessToken,
                  let refreshToken = loginUser.refreshToken else {
                return nil
            }
            return (accessToken, refreshToken)
        }
        .sink { completionResult in
            if case let .failure(error) = completionResult {
                Logger.data.critical("Error in loginUser: \(error)")
                completion(.failure(error))
            }
        } receiveValue: { credentials in
            guard let credentials else {
                completion(.failure(GraphQLErrorWrapper(msg: "Missing login credentials")))
                return
            }

            self.netID = netId
            self.accessToken = credentials.accessToken
            self.refreshToken = credentials.refreshToken

            completion(.success(()))
        }
        .store(in: &queryBag)
    }

    /// Refreshes the user's access token using the stored refresh token.
    func refreshAccessToken() {
        Network.client.mutationPublisher(
            mutation: RefreshAccessTokenMutation(),
            publishResultToStore: false,
            queue: .main
        )
        .map { result -> String? in
            result.data?.refreshAccessToken?.newAccessToken
        }
        .sink { completion in
            if case let .failure(error) = completion {
                Logger.data.critical("Error in refreshAccessToken: \(error)")
            }
        } receiveValue: { [weak self] newAccessToken in
            guard let self, let newAccessToken else { return }
            self.accessToken = newAccessToken
            Logger.data.log("Refreshed Access Token: \(newAccessToken)")
        }
        .store(in: &queryBag)
    }

    func restorePreviousSession(completion: @escaping (SessionRestoreResult) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else {
                completion(.error("Session manager deallocated"))
                return
            }

            if let error = error {
                Logger.data.critical("Failed to restore Google Sign-In: \(error.localizedDescription)")
                completion(.needsSignIn)
                return
            }

            guard let user = user else {
                Logger.data.critical("No previous Google Sign-In session found")
                completion(.needsSignIn)
                return
            }

            Logger.data.log("Restored Google Sign-In session for user: \(user.profile?.email ?? "Unknown")")

            // If we have a netID in keychain, try to restore backend session
            if let netID = self.netID {
                self.loginUser(netId: netID) { result in
                    switch result {
                    case .success:
                        Logger.data.log("Successfully restored backend session")
                        completion(.success)

                    case .failure(let error):
                        if let graphqlError = error as? GraphQLErrorWrapper,
                           graphqlError.msg.contains("No user with those credentials") {
                            Logger.data.critical("No backend user exists. Needs profile creation.")
                            completion(.needsProfileCreation)
                        } else {
                            Logger.data.critical("Failed backend login: \(error.localizedDescription)")
                            completion(.needsSignIn)
                        }
                    }
                }
            } else {
                Logger.data.critical("No netID found in Keychain. Needs sign-in.")
                completion(.needsSignIn)
            }
        }
    }

}
