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
import SwiftUI

@main
struct UpliftApp: App {

    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var locationManager = LocationManager.shared

    // MARK: - UI

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.requestLocation()
                }
        }
    }

}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data,
        didReceiveRegistrationToken fcmToken: String?
    ) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        Task {
            do {
                let id = try await Installations.installations().installationID()
                print("Installation ID: \(id)")
            } catch {
                print("Error fetching id: \(error)")
            }
        }

        Messaging.messaging().apnsToken = deviceToken
        print("Device token: \(deviceToken)")

        if let fcm = Messaging.messaging().fcmToken {
            print("FCM", fcm)
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("Device token: \(deviceToken)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("FCM", fcm)
        } else {
            print("FCM is nil")
        }
    }
}
