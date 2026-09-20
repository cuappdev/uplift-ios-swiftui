//
//  GymProximityRules.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

/// The decisions behind gym proximity banners.
struct GymProximityRules {

    // MARK: - Properties

    /// Minimum time between banners for the same gym.
    let cooldown: TimeInterval

    /// How long the user must stay inside a region before the banner fires.
    let dwell: TimeInterval

    /// The outcome of entering a gym's region.
    enum Decision: Equatable {
        case arm
        case skip(Reason)

        enum Reason {
            case checkedInToday
            case closed
            case coolingDown
        }
    }

    // MARK: - Functions

    init(dwell: TimeInterval = 5 * 60, cooldown: TimeInterval = 4 * 60 * 60) {
        self.cooldown = cooldown
        self.dwell = dwell
    }

    /// Whether a banner armed at `armedAt` is still waiting to fire.
    func bannerIsPending(armedAt: Date, now: Date) -> Bool {
        now.timeIntervalSince(armedAt) < dwell
    }

    /// What to do when the user enters `gym`.
    func decision(for gym: GymSnapshot, lastArmed: Date?, checkedInToday: Bool, now: Date) -> Decision {
        if checkedInToday { return .skip(.checkedInToday) }
        if let lastArmed, now.timeIntervalSince(lastArmed) < cooldown { return .skip(.coolingDown) }
        if !gym.hoursAreStale(at: now), !gym.isFitnessCenterOpen(at: now) { return .skip(.closed) }
        return .arm
    }

}
