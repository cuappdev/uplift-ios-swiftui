//
//  GymProximityRulesTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/20/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

struct GymProximityRulesTests {

    /**
     dwell: 5 min, how long you have to stay before the banner fires
     cooldown: 4 hours, min time between banners for the same gym

     now is a fixed date so nothing depends on the real clock
     each gym has one fitness center hours block placed relative to now
     */
    private let rules = GymProximityRules(dwell: 5 * 60, cooldown: 4 * 60 * 60)
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    private func teagle(openFrom start: TimeInterval, to end: TimeInterval) -> GymSnapshot {
        GymSnapshot(
            id: "teagle",
            name: "Teagle",
            latitude: 42.4459926380709,
            longitude: -76.47915389837931,
            fitnessCenterHours: [HoursSnapshot(startTime: now + start, endTime: now + end)]
        )
    }

    @Test("open gym with no history arms a banner")
    func openGymArms() {
        // open from 1 hour ago to 1 hour from now
        let gym = teagle(openFrom: -3600, to: 3600)
        let decision = rules.decision(for: gym, lastArmed: nil, checkedInToday: false, now: now)
        #expect(decision == .arm)
    }

    @Test("already checked in today skips even if the gym is open")
    func checkedInTodaySkips() {
        let gym = teagle(openFrom: -3600, to: 3600)
        let decision = rules.decision(for: gym, lastArmed: nil, checkedInToday: true, now: now)
        #expect(decision == .skip(.checkedInToday))
    }

    @Test("armed 1 hour ago is still in the 4 hour cooldown so it skips")
    func insideCooldownSkips() {
        let gym = teagle(openFrom: -3600, to: 3600)
        let decision = rules.decision(for: gym, lastArmed: now - 3600, checkedInToday: false, now: now)
        #expect(decision == .skip(.coolingDown))
    }

    @Test("armed just past the 4 hour cooldown arms again")
    func pastCooldownArms() {
        let gym = teagle(openFrom: -3600, to: 3600)
        // 4 hours & 1 second ago
        let lastArmed = now - (4 * 60 * 60 + 1)
        let decision = rules.decision(for: gym, lastArmed: lastArmed, checkedInToday: false, now: now)
        #expect(decision == .arm)
    }

    @Test("closed gym with current hours skips")
    func closedGymSkips() {
        // opens in 1 hour so the hours are current but its closed rn
        let gym = teagle(openFrom: 3600, to: 7200)
        let decision = rules.decision(for: gym, lastArmed: nil, checkedInToday: false, now: now)
        #expect(decision == .skip(.closed))
    }

    @Test("stale hours arm instead of staying silent")
    func staleHoursArm() {
        // every saved block already ended so we cant tell if the gym is open
        let gym = teagle(openFrom: -7200, to: -3600)
        let decision = rules.decision(for: gym, lastArmed: nil, checkedInToday: false, now: now)
        #expect(decision == .arm)
    }

    @Test("banner armed 1 min ago is still pending")
    func bannerPendingInsideDwell() {
        #expect(rules.bannerIsPending(armedAt: now - 60, now: now))
    }

    @Test("banner armed 10 min ago already fired")
    func bannerFiredAfterDwell() {
        #expect(!rules.bannerIsPending(armedAt: now - 10 * 60, now: now))
    }

    @Test("walking past & leaving doesnt block a real visit later")
    func passByThenRealVisit() {
        let gym = teagle(openFrom: -3600, to: 3 * 3600)

        // walk in, arms
        let first = rules.decision(for: gym, lastArmed: nil, checkedInToday: false, now: now)
        #expect(first == .arm)

        // walk out 1 min later, banner hadnt fired so the manager clears the record
        #expect(rules.bannerIsPending(armedAt: now, now: now + 60))

        // come back 90 min later w no record, arms again
        let second = rules.decision(for: gym, lastArmed: nil, checkedInToday: false, now: now + 90 * 60)
        #expect(second == .arm)
    }

}
