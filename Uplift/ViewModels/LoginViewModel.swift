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

    // MARK: - Functions

    func googleSignIn(success: @escaping () -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as?
            UIWindowScene)?.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController
        ) { [weak self] user, error in
            guard error == nil else { return }
            guard let email = user?.profile?.email else { return }

            if !email.contains("@cornell.edu") {
                GIDSignIn.sharedInstance.signOut()
                self?.didPresentError = true
                self?.errorText = "Please sign in with a Cornell email"
                return
            }

            success()
        }
    }
}
