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

        private let activityManager: WorkoutActivityManaging
        private let defaults: UserDefaults
        private let now: () -> Date
        private var quickStartGym: Gym?
        private var quickStartWorkoutId: String?

        init(
            activityManager: WorkoutActivityManaging = WorkoutActivityManager.shared,
            defaults: UserDefaults = .standard,
            now: @escaping () -> Date = Date.init
        ) {
            self.activityManager = activityManager
            self.defaults = defaults
            self.now = now

            let data = defaults.data(forKey: Constants.UserDefaultsKeys.activeWorkout)
            let workout = data.flatMap { try? JSONDecoder().decode(ActiveWorkout.self, from: $0) }

            if let workout, !workout.isFinished(at: now()) {
                activeWorkout = workout
            } else {
                defaults.removeObject(forKey: Constants.UserDefaultsKeys.activeWorkout)
                if let workout {
                    activityManager.finish(at: workout.autoEndDate)
                }
            }
        }

        func start(gym: Gym?, workoutId: String?) {
            guard activeWorkout == nil else { return }

            var closeTime: Date?
            if case .open(let time) = gym?.determineStatus(currentTime: now()) {
                closeTime = time
            }

            let workout = ActiveWorkout(
                gymName: gym?.name,
                closeTime: closeTime,
                workoutId: workoutId,
                startDate: now()
            )
            activeWorkout = workout
            activityManager.start(workout)
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
            finish(at: now())
        }

        func finishIfExpired(at now: Date) {
            guard let activeWorkout, activeWorkout.isFinished(at: now) else { return }
            finish(at: now)
        }

        func discard() {
            activeWorkout = nil
            expanded = false
            activityManager.cancel()
        }

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

        @discardableResult
        private func finish(at date: Date) -> ActiveWorkout? {
            let workout = activeWorkout
            activeWorkout = nil
            expanded = false
            if let workout {
                activityManager.finish(at: min(date, workout.autoEndDate))
            }
            return workout
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
