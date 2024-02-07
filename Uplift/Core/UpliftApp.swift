//
//  UpliftApp.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnnouncements
import FirebaseCore
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        AnnouncementNetworking.setupConfig(
            scheme: UpliftEnvironment.announcementsScheme,
            host: UpliftEnvironment.announcementsHost,
            commonPath: UpliftEnvironment.announcementsCommonPath,
            announcementPath: UpliftEnvironment.announcementsPath
        )
        return true
    }
}
