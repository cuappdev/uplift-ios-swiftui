//
//  WorkoutInProgressViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/29/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

extension WorkoutInProgressView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published private(set) var activeWorkout: ActiveWorkout? {
            didSet {
                saveActiveWorkout()
            }
        }

        @Published var isExpanded = false

        private let defaults: UserDefaults

        init(defaults: UserDefaults = .standard) {
            self.defaults = defaults

            let data = defaults.data(forKey: Constants.UserDefaultsKeys.activeWorkout)
            let workout = data.flatMap { try? JSONDecoder().decode(ActiveWorkout.self, from: $0) }

            if let workout, !workout.isFinished(at: .now) {
                activeWorkout = workout
            } else {
                defaults.removeObject(forKey: Constants.UserDefaultsKeys.activeWorkout)
            }
        }

        // MARK: - Functions

        func start(gym: Gym?, workoutId: String?) {
            defer { isExpanded = true }
            guard activeWorkout == nil else { return }

            var closeTime: Date?
            if case .open(let time) = gym?.determineStatus() {
                closeTime = time
            }

            activeWorkout = ActiveWorkout(gymName: gym?.name, closeTime: closeTime, workoutId: workoutId)
        }

        @discardableResult
        func finish() -> ActiveWorkout? {
            let workout = activeWorkout
            activeWorkout = nil
            isExpanded = false
            return workout
        }

        func discard() {
            activeWorkout = nil
            isExpanded = false
        }

        // MARK: - Helpers

        var subtitleText: String {
            guard let activeWorkout else { return "" }
            let date = activeWorkout.startDate.formatted(.dateTime.month(.abbreviated).day())
            return [activeWorkout.gymName, date].compactMap { $0 }.joined(separator: " · ")
        }

        func timerText(at now: Date) -> String {
            let total = elapsedSeconds(at: now)
            return String(format: "%02d : %02d : %02d", total / 3600, total % 3600 / 60, total % 60)
        }

        func durationText(at now: Date) -> String {
            let total = elapsedSeconds(at: now)
            let hours = total / 3600
            let minutes = total % 3600 / 60
            return hours > 0 ? "\(hours) h \(minutes) min" : "\(minutes) min \(total % 60) s"
        }

        private func elapsedSeconds(at now: Date) -> Int {
            Int(activeWorkout?.elapsed(at: now) ?? 0)
        }

        private func saveActiveWorkout() {
            guard let activeWorkout, let data = try? JSONEncoder().encode(activeWorkout) else {
                defaults.removeObject(forKey: Constants.UserDefaultsKeys.activeWorkout)
                return
            }
            defaults.set(data, forKey: Constants.UserDefaultsKeys.activeWorkout)
        }

    }

}
