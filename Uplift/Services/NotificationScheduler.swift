//
//  NotificationScheduler.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/17/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import UserNotifications

/// Something that can schedule and cancel local notifications.
protocol NotificationScheduling {

    func schedule(id: String, title: String, body: String, delay: TimeInterval) async throws

    func cancel(id: String)
}

/// Schedules and cancels local notifications.
final class NotificationScheduler: NotificationScheduling {

    // MARK: - Functions

    func schedule(id: String, title: String, body: String, delay: TimeInterval) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delay, 1), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        try await UNUserNotificationCenter.current().add(request)
    }

    func cancel(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

/// A notification recorded by the mock scheduler.
struct ScheduledNotification: Equatable {
    let id: String
    let title: String
    let body: String
    let delay: TimeInterval
}

/// Records notifications instead of showing them. Used in tests.
final class MockNotificationScheduler: NotificationScheduling {

    // MARK: - Properties

    private(set) var scheduled: [ScheduledNotification] = []
    private(set) var cancelled: [String] = []

    // MARK: - Functions

    func schedule(id: String, title: String, body: String, delay: TimeInterval) async throws {
        scheduled.append(ScheduledNotification(id: id, title: title, body: body, delay: delay))
    }

    func cancel(id: String) {
        cancelled.append(id)
    }
}
