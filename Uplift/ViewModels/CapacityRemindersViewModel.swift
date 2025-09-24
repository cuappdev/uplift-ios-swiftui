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
        @Published var capacityThreshold: Double = 50.0

        @Published var savedReminderId: Int?
        @Published var creatingReminder: Bool = false
        @Published var deletingReminder: Bool = false
        @Published var editingReminder: Bool = false

        private var queryBag = Set<AnyCancellable>()

        init(savedReminderId: Int? = nil) {
            self.savedReminderId = savedReminderId
            loadSavedSelections()
        }

        // MARK: - Functions

        /// load saved days & gym locations
        private func loadSavedSelections() {
            if let savedDayNumbers = UserDefaults.standard.array(forKey: "selectedDays") as? [Int] {
                selectedDays = savedDayNumbers.compactMap { DayOfWeek(rawValue: $0) }
            }

            if let savedLocations = UserDefaults.standard.array(forKey: "selectedLocations") as? [String] {
                selectedLocations = savedLocations
            }

            if let savedCapacity = UserDefaults.standard.object(forKey: "capacityThreshold") as? Double {
                capacityThreshold = savedCapacity
            }
        }

        private func saveDaysToUserDefaults() {
            let dayNumbers = selectedDays.map { $0.rawValue }
            UserDefaults.standard.set(dayNumbers, forKey: "selectedDays")
        }

        private func saveLocationsToUserDefaults() {
            UserDefaults.standard.set(selectedLocations, forKey: "selectedLocations")
        }

        private func saveCapacityToUserDefaults(_ capacity: Double) {
            UserDefaults.standard.set(capacity, forKey: "capacityThreshold")
        }

        /// Create a new capacity reminder
        func createCapacityReminder(
            capacityPercent: Int,
            daysOfWeek: [String],
            fcmToken: String,
            gyms: [String]
        ) {
            creatingReminder = true

            saveCapacityToUserDefaults(Double(capacityPercent))

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

                    UserDefaults.standard.set(id, forKey: "savedReminderId")

                    self.saveDaysToUserDefaults()
                    self.saveLocationsToUserDefaults()

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
            guard savedReminderId != nil else {
                Logger.data.error("Cannot edit reminder: no saved reminder ID")
                return
            }

            editingReminder = true

            saveCapacityToUserDefaults(Double(capacityPercent))

            let mutation = UpliftAPI.EditCapacityReminderMutation(
                capacityPercent: capacityPercent,
                daysOfWeek: daysOfWeek,
                gyms: gyms,
                reminderId: savedReminderId!
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

                    self.saveDaysToUserDefaults()
                    self.saveLocationsToUserDefaults()

                    Logger.data.info("Successfully edited capacity reminder with ID: \(id)")
                    self.editingReminder = false
                }
                .store(in: &queryBag)
        }

        /// Delete a capacity reminder
        func deleteCapacityReminder() {
            guard savedReminderId != nil else {
                Logger.data.error("Cannot delete reminder: no saved reminder ID")
                return
            }

            deletingReminder = true

            let mutation = UpliftAPI.DeleteCapacityReminderMutation(
                reminderId: savedReminderId!
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

                    self.savedReminderId = nil

                    UserDefaults.standard.removeObject(forKey: "savedReminderId")
                    UserDefaults.standard.removeObject(forKey: "selectedDays")
                    UserDefaults.standard.removeObject(forKey: "selectedLocations")
                    UserDefaults.standard.removeObject(forKey: "capacityThreshold")

                    self.deletingReminder = false

                    Logger.data.info("Successfully deleted capacity reminder with ID: \(id)")
                }
                .store(in: &queryBag)
        }
    }
}
