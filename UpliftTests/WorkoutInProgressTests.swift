//
//  WorkoutInProgressTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/1/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

@MainActor
struct WorkoutInProgressTests {

    private let now = Date(timeIntervalSince1970: 1_800_000_000)
    private let maxDuration = Constants.WorkoutInProgress.maxDuration

    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "WorkoutInProgressTests.\(UUID().uuidString)")!
    }

    private func makeViewModel(
        defaults: UserDefaults? = nil,
        at date: Date? = nil
    ) -> WorkoutInProgressView.ViewModel {
        let date = date ?? now
        return WorkoutInProgressView.ViewModel(defaults: defaults ?? makeDefaults(), now: { date })
    }

    private func makeWorkout(closeTime: Date?) -> ActiveWorkout {
        ActiveWorkout(gymName: "Teagle", closeTime: closeTime, workoutId: nil, startDate: now)
    }

    // MARK: - ActiveWorkout

    @Test("closing before the 4 hour cap ends the workout at close time")
    func endsAtCloseTime() {
        let workout = makeWorkout(closeTime: now + 3600)
        #expect(workout.autoEndDate == now + 3600)
    }

    @Test("closing after the 4 hour cap ends the workout at 4 hours")
    func capsLateCloseTime() {
        let workout = makeWorkout(closeTime: now + 6 * 3600)
        #expect(workout.autoEndDate == now + maxDuration)
    }

    @Test("no close time ends the workout at 4 hours")
    func capsWithoutCloseTime() {
        let workout = makeWorkout(closeTime: nil)
        #expect(workout.autoEndDate == now + maxDuration)
    }

    @Test("a close time that already passed falls back to 4 hours")
    func ignoresPastCloseTime() {
        let workout = makeWorkout(closeTime: now - 60)
        #expect(workout.autoEndDate == now + maxDuration)
    }

    @Test("elapsed time stops counting once the workout ends")
    func elapsedStopsAtEnd() {
        let workout = makeWorkout(closeTime: now + 3600)
        #expect(workout.elapsed(at: now + 1800) == 1800)
        #expect(workout.elapsed(at: now + 5 * 3600) == 3600)
        #expect(!workout.isFinished(at: now + 3599))
        #expect(workout.isFinished(at: now + 3600))
    }

    // MARK: - View Model

    @Test("can't expand without a workout")
    func expandNeedsWorkout() {
        let viewModel = makeViewModel()
        viewModel.isExpanded = true
        #expect(!viewModel.isExpanded)
    }

    @Test("starting a workout shows the minimized bar")
    func startShowsBar() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: "1")

        #expect(viewModel.activeWorkout?.startDate == now)
        #expect(viewModel.activeWorkout?.workoutId == "1")
        #expect(viewModel.showsMinimizedBar)
        #expect(!viewModel.isExpanded)
    }

    @Test("starting again doesn't replace the running workout")
    func startKeepsRunningWorkout() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: "1")
        viewModel.start(gym: nil, workoutId: "2")
        #expect(viewModel.activeWorkout?.workoutId == "1")
    }

    @Test("the workout only auto-finishes once its time is up")
    func finishesWhenExpired() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: nil)
        viewModel.isExpanded = true

        viewModel.finishIfExpired(at: now + maxDuration - 1)
        #expect(viewModel.activeWorkout != nil)

        viewModel.finishIfExpired(at: now + maxDuration)
        #expect(viewModel.activeWorkout == nil)
        #expect(!viewModel.isExpanded)
    }

    @Test("finishing returns the workout and clears it from storage")
    func finishClearsStorage() {
        let defaults = makeDefaults()
        let viewModel = makeViewModel(defaults: defaults)
        viewModel.start(gym: nil, workoutId: "1")

        let workout = viewModel.finish()

        #expect(workout?.workoutId == "1")
        #expect(viewModel.activeWorkout == nil)
        #expect(defaults.data(forKey: Constants.UserDefaultsKeys.activeWorkout) == nil)
    }

    @Test("discarding clears the workout and closes the screen")
    func discardClears() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: nil)
        viewModel.isExpanded = true

        viewModel.discard()

        #expect(viewModel.activeWorkout == nil)
        #expect(!viewModel.isExpanded)
    }

    @Test("quick start starts the offered workout")
    func quickStartStartsWorkout() {
        let viewModel = makeViewModel()
        viewModel.offerQuickStart(gym: nil, workoutId: "42")
        #expect(viewModel.showsQuickStart)

        viewModel.quickStart()

        #expect(!viewModel.showsQuickStart)
        #expect(viewModel.activeWorkout?.workoutId == "42")
    }

    @Test("quick start isn't offered while a workout is running")
    func quickStartSkippedWhileRunning() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: nil)
        viewModel.offerQuickStart(gym: nil, workoutId: "42")
        #expect(!viewModel.showsQuickStart)
    }

    @Test("a running workout comes back after relaunch")
    func restoresAfterRelaunch() {
        let defaults = makeDefaults()
        let viewModel = makeViewModel(defaults: defaults)
        viewModel.start(gym: nil, workoutId: "1")

        let relaunched = makeViewModel(defaults: defaults, at: now + 60)

        #expect(relaunched.activeWorkout == viewModel.activeWorkout)
    }

    @Test("a workout that ended while the app was closed is dropped on launch")
    func dropsExpiredOnLaunch() {
        let defaults = makeDefaults()
        let viewModel = makeViewModel(defaults: defaults)
        viewModel.start(gym: nil, workoutId: nil)

        let relaunched = makeViewModel(defaults: defaults, at: now + maxDuration)

        #expect(relaunched.activeWorkout == nil)
        #expect(defaults.data(forKey: Constants.UserDefaultsKeys.activeWorkout) == nil)
    }

    @Test("timer and duration text format the elapsed time")
    func formatsElapsedTime() {
        let viewModel = makeViewModel()
        viewModel.start(gym: nil, workoutId: nil)

        #expect(viewModel.timerText(at: now + 3725) == "01 : 02 : 05")
        #expect(viewModel.durationText(at: now + 3725) == "1 h 2 min")
        #expect(viewModel.durationText(at: now + 125) == "2 min 5 s")
    }

}
