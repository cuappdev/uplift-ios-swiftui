//
//  CapacityRemindersViewModel.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/27/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import OSLog
import UpliftAPI
import SwiftUI

extension CapacityRemindersView {

    /// The ViewModel for the Capacity Reminders view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var selectedDays: [DayOfWeek] = []
        @Published var selectedLocations: [String] = []

        @Published var savedReminderId: Int?
        @Published var creatingReminder: Bool = false
        @Published var deletingReminder: Bool = false
        @Published var editingReminder: Bool = false

        private var queryBag = Set<AnyCancellable>()

        // MARK: - Initialization

        init(savedReminderId: Int? = nil) {
            self.savedReminderId = savedReminderId
        }
        // MARK: - Capacity Reminder Functions

        /// Create a new capacity reminder
        func createCapacityReminder(
            capacityPercent: Int,
            daysOfWeek: [String],
            fcmToken: String,
            gyms: [String]
        ) {
            creatingReminder = true

            let mutation = UpliftAPI.CreateCapacityReminderMutation(
                capacityPercent: capacityPercent,
                daysOfWeek: daysOfWeek,
                fcmToken: fcmToken,
                gyms: gyms
            )

            Network.client.mutationPublisher(mutation: mutation)
                .map { result -> Int? in
                    if let idString = result.data?.createCapacityReminder?.id,
                       let id = Int(idString) {
                        return id
                    }
                    return nil
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("Error in creating capacity reminder: \(error)")
                    }
                    self.creatingReminder = false
                } receiveValue: { [weak self] reminderId in
                    guard let self, let id = reminderId else { return }

                    self.savedReminderId = id

                    print("Default ID: \(id) Percent: \(capacityPercent) Day of Week: \(daysOfWeek) Gyms: \(gyms)")

                    UserDefaults.standard.set(id, forKey: "savedReminderId")

                    Logger.data.info("Successfully created capacity reminder with ID: \(id)")
                    self.creatingReminder = false
                }
                .store(in: &queryBag)
        }

        /// Edit an existing capacity reminder
        func editCapacityReminder(
            capacityPercent: Int,
            daysOfWeek: [String],
            gyms: [String]
        ) {
            guard let reminderId = savedReminderId else {
                Logger.data.error("Cannot edit reminder: no saved reminder ID")
                return
            }

            editingReminder = true

            let mutation = UpliftAPI.EditCapacityReminderMutation(
                capacityPercent: capacityPercent,
                daysOfWeek: daysOfWeek,
                gyms: gyms,
                reminderId: reminderId
            )

            Network.client.mutationPublisher(mutation: mutation)
                .map { result -> Int? in
                    if let idString = result.data?.editCapacityReminder?.id,
                       let id = Int(idString) {
                        return id
                    }
                    return nil
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("Error in editing capacity reminder: \(error)")
                    }
                    self.editingReminder = false
                } receiveValue: { [weak self] reminderId in
                    guard let self, let id = reminderId else { return }

                    Logger.data.info("Successfully edited capacity reminder with ID: \(id)")

                    print("Edit ID: \(id) Percent: \(capacityPercent) Day of Week: \(daysOfWeek) Gyms: \(gyms)")

                    self.editingReminder = false
                }
                .store(in: &queryBag)
        }

        /// Delete a capacity reminder
        func deleteCapacityReminder() {
            guard let reminderId = savedReminderId else {
                Logger.data.error("Cannot delete reminder: no saved reminder ID")
                return
            }

            deletingReminder = true

            let mutation = UpliftAPI.DeleteCapacityReminderMutation(
                reminderId: reminderId
            )

            Network.client.mutationPublisher(mutation: mutation)
                .map { result -> Int? in
                    if let idString = result.data?.deleteCapacityReminder?.id,
                       let id = Int(idString) {
                        return id
                    }
                    return nil
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        Logger.data.critical("Error in deleting capacity reminder: \(error)")
                    }
                    self.deletingReminder = false
                } receiveValue: { [weak self] reminderId in
                    guard let self, let id = reminderId else { return }

                    Logger.data.info("Successfully deleted capacity reminder with ID: \(id)")
                    self.savedReminderId = nil

                    print("Success!")

                    UserDefaults.standard.removeObject(forKey: "savedReminderId")

                    self.deletingReminder = false
                }
                .store(in: &queryBag)
        }
    }
}
