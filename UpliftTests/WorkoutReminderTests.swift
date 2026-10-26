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
struct WorkoutReminderViewModelTests {

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

    // MARK: - Reminder Management

    @Test("Adding a reminder updates the list")
    func addReminder() {
        let viewModel = WorkoutReminderViewModel()
        let reminder = makeReminder()

        viewModel.addReminder(reminder)

        #expect(viewModel.reminders == [reminder])
    }

    @Test("Deleting a reminder removes it")
    func deleteReminder() {
        let viewModel = WorkoutReminderViewModel()
        let reminder = makeReminder()
        viewModel.addReminder(reminder)

        viewModel.deleteReminder(reminder)

        #expect(viewModel.reminders.isEmpty)
    }

    @Test("Editing selected days replaces the old days")
    func editSelectedDays() {
        let viewModel = WorkoutReminderViewModel()
        let original = makeReminder(days: [.monday])
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, days: [.wednesday])
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders == [updated])
    }

    @Test("Editing a reminder can add additional days")
    func addSelectedDays() {
        let viewModel = WorkoutReminderViewModel()
        let original = makeReminder(days: [.monday])
        viewModel.addReminder(original)

        let updated = makeReminder(id: original.id, days: [.monday, .friday])
        viewModel.updateReminder(updated)

        #expect(viewModel.reminders.first?.selectedDays == [.monday, .friday])
    }

    @Test("Editing an all-day reminder can set a specific time")
    func allDayToSpecificTime() {
        let viewModel = WorkoutReminderViewModel()
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
        let viewModel = WorkoutReminderViewModel()
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
        let viewModel = WorkoutReminderViewModel()
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
        let viewModel = WorkoutReminderViewModel()
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
        let viewModel = WorkoutReminderViewModel()
        let first = makeReminder()
        let second = makeReminder()
        viewModel.addReminder(first)
        viewModel.addReminder(second)

        viewModel.deleteReminder(first)

        #expect(viewModel.reminders == [second])
    }

    @Test("Editing one identical reminder preserves the other")
    func updateOnlyMatchingIdentity() {
        let viewModel = WorkoutReminderViewModel()
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
        let viewModel = WorkoutReminderViewModel()
        let existing = makeReminder()
        viewModel.addReminder(existing)

        viewModel.updateReminder(makeReminder(days: [.tuesday]))

        #expect(viewModel.reminders == [existing])
    }

    // MARK: - Time Conversion

    @Test("Midnight converts to hour zero")
    func midnight() {
        let viewModel = WorkoutReminderViewModel()
        let time = viewModel.reminderTime(makeReminder(isAllDay: false, time: "12:00 AM"))
        #expect(time?.hour == 0)
        #expect(time?.minute == 0)
    }

    @Test("Noon converts to hour twelve")
    func noon() {
        let viewModel = WorkoutReminderViewModel()
        let time = viewModel.reminderTime(makeReminder(isAllDay: false, time: "12:00 PM"))
        #expect(time?.hour == 12)
        #expect(time?.minute == 0)
    }

    @Test("Invalid time strings are rejected")
    func invalidTime() {
        let viewModel = WorkoutReminderViewModel()
        #expect(viewModel.reminderTime(makeReminder(isAllDay: false, time: "25:99 PM")) == nil)
    }

    @Test("Saving a reminder schedules notifications for all selected days")
    func schedulesNotificationsForSelectedDays() {
        let mockScheduler = MockNotificationScheduler()
        let viewModel = WorkoutReminderViewModel(notificationScheduler: mockScheduler)

        let reminder = WorkoutReminder(
            selectedDays: [.monday, .wednesday, .friday],
            isAllDay: true,
            time: "9:00 AM"
        )

        viewModel.addReminder(reminder)
        viewModel.scheduleWorkoutReminders()

        #expect(mockScheduler.scheduledWeekly.count == 3)

        for notification in mockScheduler.scheduledWeekly {
            #expect(notification.hour == 9)
            #expect(notification.minute == 0)
        }

        let scheduledDays = Set(mockScheduler.scheduledWeekly.map(\.weekday))
        let expectedDays = Set([DayOfWeek.monday, .wednesday, .friday].map(\.rawValue))

        #expect(scheduledDays == expectedDays)
    }
}
