//
//  GymSnapshot.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

/// One block of fitness center open hours.
struct HoursSnapshot: Codable, Hashable {

    // MARK: - Properties

    let endTime: Date
    let startTime: Date

    // MARK: - Functions

    /// Initializes `HoursSnapshot` with an `OpenHours` type
    init(from hours: OpenHours) {
        self.endTime = hours.endTime
        self.startTime = hours.startTime
    }

    init(startTime: Date, endTime: Date) {
        self.endTime = endTime
        self.startTime = startTime
    }
}

/// A small saveable copy of a gym, used when the app wakes in the background and GymCache is empty.
struct GymSnapshot: Codable, Hashable {

    // MARK: - Properties

    let fitnessCenterHours: [HoursSnapshot]
    let id: String
    let latitude: Double
    let longitude: Double
    let name: String

    // MARK: - Functions

    /// Initializes `GymSnapshot` with a `Gym` type
    init(from gym: Gym) {
        self.fitnessCenterHours = gym.fitnessCenters.flatMap(\.hours).map(HoursSnapshot.init(from:))
        self.id = gym.id
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.name = gym.name
    }

    init(id: String, name: String, latitude: Double, longitude: Double, fitnessCenterHours: [HoursSnapshot]) {
        self.fitnessCenterHours = fitnessCenterHours
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }

    /// True when every saved hours block has already ended,
    /// meaning that this snapshot is too old to answer whether the gym is open.
    func hoursAreStale(at date: Date = Date()) -> Bool {
        fitnessCenterHours.allSatisfy { $0.endTime < date }
    }

    func isFitnessCenterOpen(at date: Date = Date()) -> Bool {
        fitnessCenterHours.contains { $0.startTime <= date && date < $0.endTime }
    }
}
