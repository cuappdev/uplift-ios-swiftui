//
//  Array+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//

import Foundation
import UpliftAPI

extension Array where Element == Facility {

    /// Map an array of `FacilityFields` to an array of `Facility` objects.
    init(_ facilities: [FacilityFields]) {
        self.init(facilities.map(Facility.init))
    }

    /// Returns a copy of this array with duplicate facility types removed.
    func duplicatesRemoved() -> [Facility] {
        var unique = [FacilityType]()
        var result = [Facility]()
        for facility in self where !unique.contains(where: { $0 == facility.facilityType }) {
            if let facilityType = facility.facilityType {
                unique.append(facilityType)
            }
            result.append(facility)
        }
        return result
    }

}

extension Array where Element == Gym {

    /// Map an array of `GymFields` to an array of `Gym` objects.
    init(_ gyms: [GymFields]) {
        self.init(gyms.map(Gym.init))
    }

    /// Returns the facility given an ID.
    func facilityWithID(id: String) -> Facility? {
        for gym in self {
            if let facility = gym.facilities.first(where: { $0.id == id }) {
                return facility
            }
        }
        return nil
    }

    /// Returns an array of all facilities.
    func getAllFacilities() -> [Facility] {
        self.flatMap(\.facilities)
    }

    /// Returns an array of all fitness centers.
    func getAllFitnessCenters() -> [Facility] {
        self.flatMap(\.facilities).filter { $0.facilityType == .fitness }
    }

}

extension Array where Element == OpenHours {

    /// Map an array of `OpenHoursFields` to an array of `OpenHours` objects.
    init(_ openHours: [OpenHoursFields]) {
        self.init(openHours.map(OpenHours.init))
    }

    /**
     Retrieve the status of the `Gym` or `Facility` depending on its hours.

     - Parameters:
        - currentTime: The current time to compare determine the status. Default is now.

     - Returns: A `Status` object based on its hours.
     */
    func getStatus(currentTime: Date = Date.now) -> Status? {
        // Remove dates in the past
        var filtered = self.sorted().filter { $0.endTime > currentTime }

        // Get earliest date
        guard let earliest = filtered.min() else { return nil }

        if currentTime < earliest.startTime {
            // Not open yet
            return .closed(openTime: earliest.startTime)
        } else if currentTime >= earliest.startTime && currentTime < earliest.endTime {
            // Currently open, closing soon
            return .open(closeTime: earliest.endTime)
        } else {
            // Current closed
            guard let secondEarliest = filtered.sorted().first(where: {
                $0.startTime > currentTime
            }) else {
                return nil
            }
            return .closed(openTime: secondEarliest.startTime)
        }
    }

}
