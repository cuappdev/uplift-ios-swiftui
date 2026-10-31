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

        @Published private var expanded = false
        @Published var showsQuickStart = false

        var isExpanded: Bool {
            get { expanded && activeWorkout != nil }
            set { expanded = newValue }
        }

        private let defaults: UserDefaults
        private var quickStartGym: Gym?
        private var quickStartWorkoutId: String?

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
            guard activeWorkout == nil else {
                expanded = true
                return
            }

            var closeTime: Date?
            if case .open(let time) = gym?.determineStatus() {
                closeTime = time
            }

            activeWorkout = ActiveWorkout(gymName: gym?.name, closeTime: closeTime, workoutId: workoutId)

            Task { [weak self] in
                try? await Task.sleep(for: .seconds(Constants.WorkoutInProgress.expandDelay))
                self?.expanded = true
            }
        }

        func offerQuickStart(gym: Gym?, workoutId: String?) {
            guard activeWorkout == nil else { return }
            quickStartGym = gym
            quickStartWorkoutId = workoutId
            showsQuickStart = true
        }

        func quickStart() {
            showsQuickStart = false
            start(gym: quickStartGym, workoutId: quickStartWorkoutId)
        }

        @discardableResult
        func finish() -> ActiveWorkout? {
            let workout = activeWorkout
            activeWorkout = nil
            expanded = false
            return workout
        }

        func finishIfExpired(at now: Date) {
            guard let activeWorkout, activeWorkout.isFinished(at: now) else { return }
            finish()
        }

        func discard() {
            activeWorkout = nil
            expanded = false
        }

        // MARK: - Helpers

        var showsMinimizedBar: Bool {
            activeWorkout != nil && !isExpanded
        }

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
