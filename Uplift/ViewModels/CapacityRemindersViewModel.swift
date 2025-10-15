//
//  CapacityRemindersViewModel.swift
//  Uplift
//
//  Created by Jiwon Jeong on 9/25/25.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Combine
import Foundation
import OSLog
import UpliftAPI
import SwiftUI
import FirebaseMessaging

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

        @Published var showInfo = false
        @Published var fcmToken: String = ""

        @Published var showUnsavedChangesModal = false
        @Published var hasUnsavedChanges: Bool = false

        @Published var originalSelectedDays: [DayOfWeek] = []
        @Published var originalCapacityThreshold: Double = 50
        @Published var originalSelectedLocations: [String] = []
        @Published var originalShowInfo: Bool = false

        @Published var isLoading: Bool = false

        @Published var errorMessage: String?

        var onDismiss: (() -> Void)?

        private var queryBag = Set<AnyCancellable>()

        init(savedReminderId: Int? = nil) {
            if let id = savedReminderId {
                self.savedReminderId = id
                loadSavedSelections()
                self.showInfo = true
                self.originalShowInfo = true
            } else {
                self.showInfo = false
                self.originalShowInfo = false
            }
        }

        // MARK: - Functions

        func cleanupLocalReminderData() {
            self.savedReminderId = nil
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.reminderId)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.selectedDays)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.selectedLocations)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.capacityThreshold)
            Logger.data.info("Cleaned up local reminder data due to remote not found error")
        }

        /// retrieves the FCM token
        func getFCMToken() {
            Messaging.messaging().token { token, error in
                if let error = error {
                    Logger.data.info("Error getting FCM token: \(error.localizedDescription)")
                } else if let token = token {
                    Logger.data.info("FCM TOKEN: \(token)")
                    self.fcmToken = token
                    UIPasteboard.general.string = token
                }
            }
        }

        /// checks for unsaved changes
        func checkForUnsavedChanges() {
            hasUnsavedChanges = (
                showInfo != originalShowInfo ||
                selectedDays != originalSelectedDays ||
                capacityThreshold != originalCapacityThreshold ||
                selectedLocations != originalSelectedLocations
            )
        }

        /// saves original values when needed
        func saveOriginalValues() {
            originalSelectedDays = selectedDays
            originalCapacityThreshold = capacityThreshold
            originalSelectedLocations = selectedLocations
            originalShowInfo = showInfo
        }

        /// creates a default reminder if toggle is on; if off, deletes it from the local storage
        func handleToggleChange(isOn: Bool) {
            if isOn {
                if savedReminderId == nil {
                    createDefaultReminder()
                }
            } else {
                if savedReminderId != nil {
                    deleteCapacityReminder()
                }
            }
            checkForUnsavedChanges()
        }

        /// creates a default reminder
        func createDefaultReminder() {
            errorMessage = nil

            if selectedDays.isEmpty {
                errorMessage = "Please select at least one day"
                return
            }

            if selectedLocations.isEmpty {
                errorMessage = "Please select at least one gym"
                return
            }

            let daysOfWeekStrings = selectedDays.map { $0.dayOfWeekComplete().uppercased() }

            createCapacityReminder(
                capacityPercent: Int(capacityThreshold),
                daysOfWeek: daysOfWeekStrings,
                fcmToken: fcmToken,
                gyms: selectedLocations
            )
        }

        /// edits the device's reminder
        func saveReminder(onComplete: (() -> Void)? = nil) {
            showUnsavedChangesModal = false
            errorMessage = nil

            if selectedDays.isEmpty {
                errorMessage = "Please select at least one day."
                return
            }

            if selectedLocations.isEmpty {
                errorMessage = "Please select at least one gym."
                return
            }

            if savedReminderId != nil {
                let daysOfWeekStrings = selectedDays.map { $0.dayOfWeekComplete().uppercased() }

                editCapacityReminder(
                    capacityPercent: Int(capacityThreshold),
                    daysOfWeek: daysOfWeekStrings,
                    gyms: selectedLocations,
                    onComplete: onComplete
                )
            }

            saveOriginalValues()
            hasUnsavedChanges = false
        }

        /// load saved days & gym locations
        func loadSavedSelections() {
            if let savedDayNumbers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKeys.selectedDays) as? [Int] {
                selectedDays = savedDayNumbers.compactMap { DayOfWeek(rawValue: $0) }
            }

            if let savedLocations = UserDefaults.standard.array(forKey: Constants.UserDefaultsKeys.selectedLocations) as? [String] {
                selectedLocations = savedLocations
            }

            if let savedCapacity = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.capacityThreshold) as? Double {
                capacityThreshold = savedCapacity
            }
        }

        private func saveDaysToUserDefaults() {
            let dayNumbers = selectedDays.map { $0.rawValue }
            UserDefaults.standard.set(dayNumbers, forKey: Constants.UserDefaultsKeys.selectedDays)
        }

        private func saveLocationsToUserDefaults() {
            UserDefaults.standard.set(selectedLocations, forKey: Constants.UserDefaultsKeys.selectedLocations)
        }

        private func saveCapacityToUserDefaults(_ capacity: Double) {
            UserDefaults.standard.set(capacity, forKey: Constants.UserDefaultsKeys.capacityThreshold)
        }

        /// Helper function to execute two tasks concurrently with Task Groups
        private func executeWithMinimumDelay(_ operation: @escaping (@escaping () -> Void) -> AnyCancellable) async {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [weak self] in
                    await withCheckedContinuation { continuation in
                        let cancellable = operation {
                            continuation.resume()
                        }

                        Task { @MainActor [weak self] in
                            cancellable.store(in: &self!.queryBag)
                        }
                    }
                }

                group.addTask {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                }

                await group.waitForAll()
            }
        }

        /// Create a new capacity reminder
        func createCapacityReminder(
            capacityPercent: Int,
            daysOfWeek: [String],
            fcmToken: String,
            gyms: [String]
        ) {
            isLoading = true
            creatingReminder = true
            saveCapacityToUserDefaults(Double(capacityPercent))

            let mutation = UpliftAPI.CreateCapacityReminderMutation(
                capacityPercent: capacityPercent,
                daysOfWeek: daysOfWeek,
                fcmToken: fcmToken,
                gyms: gyms
            )

            Task {
                await executeWithMinimumDelay { [weak self] completion in
                    guard let self else {
                        completion()
                        return AnyCancellable {}
                    }

                    return Network.client.mutationPublisher(mutation: mutation)
                        .map { result -> Int? in
                            if let idString = result.data?.createCapacityReminder?.id,
                               let id = Int(idString) {
                                return id
                            }
                            return nil
                        }
                        .sink { sinkCompletion in
                            if case let .failure(error) = sinkCompletion {
                                self.cleanupLocalReminderData()
                                Logger.data.critical("Error in creating capacity reminder: \(error)")
                            }
                            completion()
                        } receiveValue: { [weak self] reminderId in
                            guard let self, let id = reminderId else { return }

                            self.savedReminderId = id
                            UserDefaults.standard.set(id, forKey: Constants.UserDefaultsKeys.reminderId)
                            self.saveDaysToUserDefaults()
                            self.saveLocationsToUserDefaults()
                            Logger.data.info("Successfully created capacity reminder with ID: \(id)")
                        }
                }

                await MainActor.run {
                    self.isLoading = false
                    self.creatingReminder = false
                }
            }
        }

        /// Edit an existing capacity reminder
        func editCapacityReminder(
            capacityPercent: Int,
            daysOfWeek: [String],
            gyms: [String],
            onComplete: (() -> Void)? = nil
        ) {
            guard savedReminderId != nil else {
                Logger.data.error("Cannot edit reminder: no saved reminder ID")
                return
            }

            isLoading = true
            editingReminder = true
            saveCapacityToUserDefaults(Double(capacityPercent))

            let mutation = UpliftAPI.EditCapacityReminderMutation(
                capacityPercent: capacityPercent,
                daysOfWeek: daysOfWeek,
                gyms: gyms,
                reminderId: savedReminderId!
            )

            Task {
                await executeWithMinimumDelay { [weak self] completion in
                    guard let self else {
                        completion()
                        return AnyCancellable {}
                    }

                    return Network.client.mutationPublisher(mutation: mutation)
                        .map { result -> Int? in
                            if let idString = result.data?.editCapacityReminder?.id,
                               let id = Int(idString) {
                                return id
                            }
                            return nil
                        }
                        .sink { sinkCompletion in
                            if case let .failure(error) = sinkCompletion {
                                self.cleanupLocalReminderData()
                                Logger.data.critical("Error in editing capacity reminder: \(error)")
                            }
                            completion()
                        } receiveValue: { [weak self] reminderId in
                            guard let self, let id = reminderId else { return }

                            self.saveDaysToUserDefaults()
                            self.saveLocationsToUserDefaults()
                            Logger.data.info("Successfully edited capacity reminder with ID: \(id)")
                        }
                }

                await MainActor.run {
                    self.isLoading = false
                    self.editingReminder = false
                    onComplete?()
                }
            }
        }

        /// Delete a capacity reminder
        func deleteCapacityReminder() {
            guard savedReminderId != nil else {
                Logger.data.error("Cannot delete reminder: no saved reminder ID")
                return
            }

            errorMessage = nil
            isLoading = true
            deletingReminder = true

            let mutation = UpliftAPI.DeleteCapacityReminderMutation(
                reminderId: savedReminderId!
            )

            Task {
                await executeWithMinimumDelay { [weak self] completion in
                    guard let self else {
                        completion()
                        return AnyCancellable {}
                    }

                    return Network.client.mutationPublisher(mutation: mutation)
                        .map { result -> Int? in
                            if let idString = result.data?.deleteCapacityReminder?.id,
                               let id = Int(idString) {
                                return id
                            }
                            return nil
                        }
                        .sink { sinkCompletion in
                            if case let .failure(error) = sinkCompletion {
                                self.cleanupLocalReminderData()
                                Logger.data.critical("Error in deleting capacity reminder: \(error)")
                            }
                            completion()
                        } receiveValue: { [weak self] reminderId in
                            guard let self, let id = reminderId else { return }

                            self.savedReminderId = nil
                            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.reminderId)
                            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.selectedDays)
                            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.selectedLocations)
                            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.capacityThreshold)
                            Logger.data.info("Successfully deleted capacity reminder with ID: \(id)")
                        }
                }

                await MainActor.run {
                    self.isLoading = false
                    self.deletingReminder = false
                }
            }
        }
    }
}
