//
//  UpliftApp.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import FirebaseCore
import GoogleSignIn
import SwiftUI

@main
struct UpliftApp: App {

    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var locationManager = LocationManager.shared
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
                            .environmentObject(locationManager)
                            .onAppear {
                                locationManager.requestLocation()
                            }
                    ) : nil
                }
            }
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            FirebaseApp.configure()
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    // TODO: - Show the app's signed-out state.
                } else {
                    // TODO: - Show the app's signed-in state.
                }
            }
            return true
        }

        func application(_ app: UIApplication,
                         open url: URL,
                         options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
            GIDSignIn.sharedInstance.handle(url)
        }
    }
}
