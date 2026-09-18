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
    let startTime: Date
    let endTime: Date
    
    // MARK: - Functions
    
    ///Initializes`HoursSnapshot` with a `OpenHours` type
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
    
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let fitnessCenterHours: [HoursSnapshot]
    
    // MARK: - Functions

    /// Initializes`GymSnapshot` with a `Gym` type
    init(from gym: Gym) {
        self.id = gym.id
        self.name = gym.name
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.fitnessCenterHours = gym.fitnessCenters.flatMap(\.hours).map(HoursSnapshot.init(from:))
    }
    
    init(id: String, name: String, latitude: Double, longitude: Double, fitnessCenterHours: [HoursSnapshot]) {
            self.id = id
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
            self.fitnessCenterHours = fitnessCenterHours
    }
    
    func isFitnessCenterOpen(at date: Date = Date()) -> Bool {
        fitnessCenterHours.contains { $0.startTime <= date && date < $0.endTime }
    }

    /// True when every saved hours block has already ended,
    /// meaning that this snapshot is too old to answer whether the gym is open.
    func hoursAreStale(at date: Date = Date()) -> Bool {
        fitnessCenterHours.allSatisfy { $0.endTime < date }
    }
}
