//
//  LoginViewModel.swift
//  Uplift
//
//  Created by Belle Hu on 10/16/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import GoogleSignIn
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {

    // MARK: - Properties

    @Published var didPresentError: Bool = false
    @Published var errorText: String = ""
    private let signInConfig = GIDConfiguration.init(clientID: UpliftEnvironment.Keys.googleClientID)
    private let cornellDomain = "@cornell.edu"

    // MARK: - Functions

    func googleSignIn(success: @escaping (_ email: String, _ name: String, _ netID: String) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as?
            UIWindowScene)?.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController
        ) { [weak self] user, error in
            guard let self else { return }
            guard error == nil else { return }
            guard let email = user?.profile?.email else { return }

            if !isValidEmail(email) {
                GIDSignIn.sharedInstance.signOut()
                self.didPresentError = true
                self.errorText = "Please sign in with a Cornell email or approved reviewer account"
                return
            }

            guard let fullName = user?.profile?.name else { return }
            let netID = netID(from: email)

            success(email, fullName, netID)
        }
    }

    /// Returns whether the email is a Cornell email or one of the app review allowed emails.
    private func isValidEmail(_ email: String) -> Bool {
        email.hasSuffix(cornellDomain) || UpliftEnvironment.appReviewAllowedEmails.contains(email)
    }

    /// Returns the Cornell NetID from the email. If it's a non-Cornell email, returns the email prefix.
    private func netID(from email: String) -> String {
        if email.hasSuffix(cornellDomain) {
            return email.replacingOccurrences(of: cornellDomain, with: "")
        }

        // For non-Cornell accounts, just use the email prefix
        return email.split(separator: "@").first.map(String.init) ?? email
    }
}
