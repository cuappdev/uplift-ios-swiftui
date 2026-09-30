//
//  CheckInRemindersViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/26/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Combine
import CoreLocation
import SwiftUI
import UserNotifications

extension CheckInRemindersView {

    /// The ViewModel for the Check-In Reminders view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var isEnabled: Bool
        @Published var authorizationStatus: CLAuthorizationStatus
        @Published var notificationsDenied = false

        /// true when reminders are on but ios cant wake the app for a gym visit yet
        var needsAlwaysLocation: Bool {
            isEnabled && authorizationStatus != .authorizedAlways
        }

        private var queryBag = Set<AnyCancellable>()

        init() {
            isEnabled = GymProximityManager.shared.isEnabled
            authorizationStatus = LocationManager.shared.authorizationStatus

            GymProximityManager.shared.$isEnabled
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isEnabled in
                    self?.isEnabled = isEnabled
                }
                .store(in: &queryBag)

            LocationManager.shared.authorizationStatusPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] status in
                    self?.authorizationStatus = status
                }
                .store(in: &queryBag)
        }

        // MARK: - Functions

        /// turns check-in reminders on or off when the toggle changes
        func handleToggleChange(isOn: Bool) {
            if isOn {
                Task { await GymProximityManager.shared.enable() }
            } else {
                GymProximityManager.shared.disable()
            }
        }

        /// checks if notifications for uplift are turned off in settings
        func refreshNotificationSettings() async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            notificationsDenied = settings.authorizationStatus == .denied
        }

    }

}
