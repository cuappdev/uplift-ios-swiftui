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

    func scheduleWeekly(
        id: String,
        title: String,
        body: String,
        weekday: Int,
        hour: Int,
        minute: Int
    )
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

    func scheduleWeekly(id: String, title: String, body: String, weekday: Int, hour: Int, minute: Int) {
        //contents of the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        //when the notification should happen
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                Logger.services.error("Failed to schedule notification \(id): \(error)")
            }
        }
    }
}

/// A notification recorded by the mock scheduler.
struct ScheduledNotification: Equatable {
    let id: String
    let title: String
    let body: String
    let delay: TimeInterval
}

struct ScheduledWeeklyNotification: Equatable {
    let id: String
    let title: String
    let body: String
    let weekday: Int
    let hour: Int
    let minute: Int
}

/// Records notifications instead of showing them. Used in tests.
final class MockNotificationScheduler: NotificationScheduling {

    // MARK: - Properties

    private(set) var scheduled: [ScheduledNotification] = []
    private(set) var cancelled: [String] = []
    private(set) var scheduledWeekly: [ScheduledWeeklyNotification] = []

    // MARK: - Functions

    func schedule(id: String, title: String, body: String, delay: TimeInterval) async throws {
        scheduled.append(ScheduledNotification(id: id, title: title, body: body, delay: delay))
    }

    func cancel(id: String) {
        cancelled.append(id)
    }

    func scheduleWeekly(id: String, title: String, body: String, weekday: Int, hour: Int, minute: Int) {
        scheduledWeekly.append(ScheduledWeeklyNotification(id: id, title: title, body: body, weekday: weekday, hour: hour, minute: minute))
    }
}
