//
//  UpliftApp.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import SwiftUI

@main
struct UpliftApp: App {

    // MARK: - Properties

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
