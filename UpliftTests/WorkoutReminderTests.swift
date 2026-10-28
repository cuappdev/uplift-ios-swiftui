//
//  WorkoutReminderTests.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/26/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

@MainActor
struct WorkoutReminderTests {

    private struct TestDependencies {
        let viewModel: WorkoutReminderViewModel
        let scheduler: MockNotificationScheduler
        let defaults: UserDefaults
    }

    private func makeReminder(
        id: UUID = UUID(),
        days: [DayOfWeek] = [.monday],
        isAllDay: Bool = true,
        time: String = "9:00 AM"
    ) -> WorkoutReminder {
        WorkoutReminder(
            id: id,
            selectedDays: days,
            isAllDay: isAllDay,
            time: time
        )
    }

    private func makeViewModel() -> TestDependencies {
        let mockScheduler = MockNotificationScheduler()
        let testDefaults = UserDefaults(
            suiteName: "WorkoutReminderTests.\(UUID().uuidString)"
        )!

        let viewModel = WorkoutReminderViewModel(
            notificationScheduler: mockScheduler,
            userDefaults: testDefaults
        )

        return TestDependencies(
            viewModel: viewModel,
            scheduler: mockScheduler,
            defaults: testDefaults
        )
    }

    // MARK: - Reminder Management

    @Test("Adding a reminder updates the list")
    func addReminder() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let reminder = makeReminder()

        viewModel.addReminder(reminder)

        #expect(viewModel.reminders == [reminder])
    }

    @Test("Deleting a reminder removes it")
    func deleteReminder() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let reminder = makeReminder()
        viewModel.addReminder(reminder)

        viewModel.deleteReminder(reminder)

        #expect(viewModel.reminders.isEmpty)
    }

    @Test("Editing selected days replaces the old days")
    func editSelectedDays() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let original = makeReminder(days: [.monday])
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, days: [.wednesday])
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated])
    }

    @Test("Editing a reminder can add additional days")
    func addSelectedDays() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let original = makeReminder(days: [.monday])
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, days: [.monday, .friday])
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders.first?.selectedDays == [.monday, .friday])
    }

    @Test("Editing an all-day reminder can set a specific time")
    func allDayToSpecificTime() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let original = makeReminder()
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, isAllDay: false, time: "3:30 PM")
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated])
        #expect(viewModel.reminderTime(updated)?.hour == 15)
        #expect(viewModel.reminderTime(updated)?.minute == 30)
    }

    @Test("Editing a timed reminder can switch to all-day")
    func specificTimeToAllDay() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let original = makeReminder(isAllDay: false, time: "6:15 PM")
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, isAllDay: true, time: "9:00 AM")
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated])
        #expect(viewModel.reminderTime(updated)?.hour == 9)
        #expect(viewModel.reminderTime(updated)?.minute == 0)
    }

    @Test("Editing a timed reminder can change its time")
    func changeSpecificTime() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let original = makeReminder(isAllDay: false, time: "7:00 AM")
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, isAllDay: false, time: "8:45 PM")
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated])
        #expect(viewModel.reminderTime(updated)?.hour == 20)
        #expect(viewModel.reminderTime(updated)?.minute == 45)
    }

    @Test("Reminders with identical settings have separate identities")
    func identicalRemindersCanCoexist() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let first = makeReminder()
        let second = makeReminder()

        viewModel.addReminder(first)
        viewModel.addReminder(second)

        #expect(first.id != second.id)
        #expect(viewModel.reminders.count == 2)
        #expect(viewModel.reminders.contains(first))
        #expect(viewModel.reminders.contains(second))
    }

    @Test("Deleting one identical reminder preserves the other")
    func deleteOnlyMatchingIdentity() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let first = makeReminder()
        let second = makeReminder()
        viewModel.addReminder(first)
        viewModel.addReminder(second)

        viewModel.deleteReminder(first)

        #expect(viewModel.reminders == [second])
    }

    @Test("Editing one identical reminder preserves the other")
    func updateOnlyMatchingIdentity() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let first = makeReminder()
        let second = makeReminder()
        viewModel.addReminder(first)
        viewModel.addReminder(second)

        let updated = makeReminder(id: first.id, days: [.thursday])
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated, second])
    }

    @Test("Updating a missing reminder leaves existing reminders unchanged")
    func updateMissingReminder() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let existing = makeReminder()
        viewModel.addReminder(existing)

        viewModel.updateReminder(makeReminder(days: [.tuesday]))

        #expect(viewModel.reminders == [existing])
    }

    // MARK: - Time Conversion

    @Test("Midnight converts to hour zero")
    func midnight() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let time = viewModel.reminderTime(makeReminder(isAllDay: false, time: "12:00 AM"))
        #expect(time?.hour == 0)
        #expect(time?.minute == 0)
    }

    @Test("Noon converts to hour twelve")
    func noon() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        let time = viewModel.reminderTime(makeReminder(isAllDay: false, time: "12:00 PM"))
        #expect(time?.hour == 12)
        #expect(time?.minute == 0)
    }

    @Test("Invalid time strings are rejected")
    func invalidTime() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel

        #expect(viewModel.reminderTime(makeReminder(isAllDay: false, time: "25:99 PM")) == nil)
    }

    @Test("Saving a reminder schedules notifications for all selected days")
    func schedulesNotificationsForSelectedDays() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel
        let mockScheduler = dependencies.scheduler

        let reminder = WorkoutReminder(
            selectedDays: [.monday, .wednesday, .friday],
            isAllDay: true,
            time: "9:00 AM"
        )

        viewModel.addReminder(reminder)

        #expect(mockScheduler.scheduledWeekly.count == 3)

        for notification in mockScheduler.scheduledWeekly {
            #expect(notification.hour == 9)
            #expect(notification.minute == 0)
        }

        let scheduledDays = Set(mockScheduler.scheduledWeekly.map(\.weekday))
        let expectedDays = Set([DayOfWeek.monday, .wednesday, .friday].map(\.rawValue))

        #expect(scheduledDays == expectedDays)
    }

    @Test("Adding a reminder automatically persists it")
    func addReminderPersists() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel
        let mockScheduler = dependencies.scheduler
        let testDefaults = dependencies.defaults

        let reminder = makeReminder()

        viewModel.addReminder(reminder)

        let data = testDefaults.data(
            forKey: Constants.UserDefaultsKeys.workoutReminders
        )

        #expect(data != nil)

        if let data {
            let savedReminders = try? JSONDecoder().decode([WorkoutReminder].self, from: data)
            #expect(savedReminders == [reminder])
        }
    }

    @Test("Editing reminder days cancels old notifications and schedules new ones")
    func updateReminderNotifications() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel
        let mockScheduler = dependencies.scheduler

        let original = makeReminder(days: [.monday])
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, days: [.wednesday])
        viewModel.updateReminder(updated)

        let mondayId = "workoutReminder.\(original.id.uuidString)-\(DayOfWeek.monday.rawValue)"

        #expect(mockScheduler.cancelled.contains(mondayId))
        #expect(mockScheduler.scheduledWeekly.last?.weekday == DayOfWeek.wednesday.rawValue)
    }

    @Test("Deleting a reminder cancels its scheduled notifications")
    func deleteReminderNotifications() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel
        let mockScheduler = dependencies.scheduler

        let reminder = makeReminder(days: [.monday, .friday])
        viewModel.addReminder(reminder)
        viewModel.deleteReminder(reminder)

        let mondayId = "workoutReminder.\(reminder.id.uuidString)-\(DayOfWeek.monday.rawValue)"
        let fridayId = "workoutReminder.\(reminder.id.uuidString)-\(DayOfWeek.friday.rawValue)"

        #expect(mockScheduler.cancelled.contains(mondayId))
        #expect(mockScheduler.cancelled.contains(fridayId))
    }

    @Test("Editing one reminder preserves another reminder's notifications")
    func updateOnlyOneReminderNotifications() {
        let dependencies = makeViewModel()
        let viewModel = dependencies.viewModel
        let mockScheduler = dependencies.scheduler

        let first = makeReminder(days: [.monday])
        let second = makeReminder(days: [.friday])

        viewModel.addReminder(first)
        viewModel.addReminder(second)

        let updated = makeReminder(id: first.id, days: [.wednesday])
        viewModel.updateReminder(updated)

        let secondId = "workoutReminder.\(second.id.uuidString)-\(DayOfWeek.friday.rawValue)"

        #expect(!mockScheduler.cancelled.contains(secondId))
    }
}
