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

        // MARK: - Session State

        enum SessionState {
            case restoring
            case signedOut
            case guest
            case creatingProfile
            case settingGoals
            case signedIn
        }

        // MARK: - Properties

        @Published var userId: Int?
        @Published var email: String = ""
        @Published var instagram: String = ""
        @Published var name: String = ""
        @Published var netID: String = ""
        @Published var popUpGiveaway: Bool = false
        @Published var profileImage: UIImage?
        @Published var didClickSubmit: Bool = false
        @Published var showGiveawayErrorAlert: Bool = false
        @Published var submitSuccessful: Bool = false
        @Published var showWorkoutCheckIn: Bool = true

        @Published var sessionState: SessionState {
            didSet {
                defaults.set(sessionState == .guest, forKey: Constants.UserDefaultsKeys.skippedLogin)
            }
        }

        /// true when the user tapped skip on sign-in
        var isSkipped: Bool {
            sessionState == .guest
        }

        private let defaults: UserDefaults
        private var queryBag = Set<AnyCancellable>()

        init(defaults: UserDefaults = .standard) {
            self.defaults = defaults
            sessionState = defaults.bool(forKey: Constants.UserDefaultsKeys.skippedLogin) ? .guest : .restoring
        }

        /// Clears draft onboarding data that must not carry across sessions (e.g. after log out or account deletion).
        func resetOnboardingDraftState() {
            profileImage = nil
            userId = nil
        }

        /// sets the session state from the restore result
        func apply(_ result: SessionRestoreResult) {
            switch result {
            case .success, .offline:
                sessionState = .signedIn
            case .needsSignIn, .needsProfileCreation:
                sessionState = isSkipped ? .guest : .signedOut
            case .error(let message):
                Logger.data.critical("Session restore error: \(message)")
                sessionState = isSkipped ? .guest : .signedOut
            }
        }

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
        func createUser(completion: @escaping () -> Void) {
            createUserRequest {
                UserSessionManager.shared.loginUser(netId: self.netID) { result in
                    switch result {
                    case .success:
                        Logger.data.log("Successfully logged in after creating user")
                        self.sessionState = .signedIn

                        UserSessionManager.shared.email = self.email
                        completion()
                    case .failure(let error):
                        if let graphqlError = error as? GraphQLErrorWrapper,
                           graphqlError.msg.contains("No user with those credentials") {
                            Logger.data.critical("No user found, show onboarding flow or retry")
                            self.sessionState = .signedOut
                        } else {
                            Logger.data.critical("Unexpected login error: \(error.localizedDescription)")
                        }
                    }
                }
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

            let resizedImage = profileImage?.resized()

            let base64Image: String? = resizedImage?
                .jpegData(compressionQuality: 0.2)?
                .base64EncodedString()

            Network.client.mutationPublisher(
                mutation: CreateUserMutation(
                    email: self.email,
                    encodedImage: base64Image.map { GraphQLNullable.some($0) } ?? .none,
                    name: self.name,
                    netId: netID
                )
            )
            .compactMap(\.data?.createUser)
            .sink { completion in
                if case let .failure(error) = completion {
                    callback() // If user already created (error thrown), still enter giveaway
                    Logger.data.critical("Error in MainViewModel.createUserRequest: \(error)")
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.userId = Int(user.id)
                callback()
#if DEBUG
                Logger.data.log("Created a new user with NetID \(user.netId)")
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
