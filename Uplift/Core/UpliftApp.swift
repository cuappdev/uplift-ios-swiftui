//
//  UpliftApp.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging
import FirebaseInstallations
import GoogleSignIn
import OSLog
import SwiftUI

@main
struct UpliftApp: App {

    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var mainViewModel = MainView.ViewModel()

    // MARK: - UI

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    (mainViewModel.showSignInView) ? (
                        SignInView()
                            .environmentObject(mainViewModel)
                            .onOpenURL { url in
                                GIDSignIn.sharedInstance.handle(url)
                            }
                    ) : nil

                    (mainViewModel.showCreateProfileView) ? (
                        CreateProfileView()
                            .environmentObject(mainViewModel)
                    ) : nil

                    (mainViewModel.showMainView) ? (
                        MainView()
                            .onAppear {
                                LocationManager.shared.requestLocation()
                            }
                    ) : nil
                }
            }
            .onAppear {
                restoreUserSession()
            }
        }
    }

    // MARK: Restore Previous Sign-in

    private func restoreUserSession() {
        UserSessionManager.shared.restorePreviousSession { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.mainViewModel.showMainView = true
                    self.mainViewModel.showSignInView = false
                    self.mainViewModel.showCreateProfileView = false
                case .needsSignIn:
                    self.mainViewModel.showSignInView = true
                    self.mainViewModel.showCreateProfileView = false
                    self.mainViewModel.showMainView = false
                case .needsProfileCreation:
                    self.mainViewModel.showSignInView = false
                    self.mainViewModel.showCreateProfileView = true
                    self.mainViewModel.showMainView = false
                case .error(let message):
                    Logger.data.critical("Session restore error: \(message)")
                    self.mainViewModel.showSignInView = true
                    self.mainViewModel.showCreateProfileView = false
                    self.mainViewModel.showMainView = false
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // TODO: - Show the app's signed-out state.
            } else {
                // TODO: - Show the app's signed-in state.
            }
        }

        // Configure Firebase Cloud Messaging
        Messaging.messaging().delegate = self

        // Configure push notifications
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs token retrieved: \(tokenString)")

        // Passes the APNs token to Firebase Cloud Messaging (FCM)
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }

        Task {
            do {
                let id = try await Installations.installations().installationID()
                print("Installation ID: \(id)")
            } catch {
                print("Error fetching id: \(error)")
            }
        }
    }
}
