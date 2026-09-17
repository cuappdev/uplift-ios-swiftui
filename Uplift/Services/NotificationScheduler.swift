//
//  NotificationScheduler.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/17/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import UserNotifications

protocol NotificationScheduling {

    func schedule(id: String, title: String, body: String, delay: TimeInterval)

    func cancel(id: String)
}

/// Schedules and cancels local notifications.
final class NotificationScheduler: NotificationScheduling {

    // MARK: - Functions

    func schedule(id: String, title: String, body: String, delay: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                Logger.services.error("Failed to schedule notification \(id): \(error)")
            }
        }
    }

    func cancel(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

final class MockNotificationScheduler: NotificationScheduling {

    // MARK: - Properties

    private(set) var scheduled: [(id: String, title: String, body: String, delay: TimeInterval)] = []

    private(set) var cancelled: [String] = []

    // MARK: - Functions

    func schedule(id: String, title: String, body: String, delay: TimeInterval) {
        scheduled.append((id, title, body, delay))
    }

    func cancel(id: String) {
        cancelled.append(id)
    }
}
