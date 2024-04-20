//
//  Array+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

extension Array where Element == Equipment {

    /// Map an array of `EquipmentFields` to an array of `Equipment` objects.
    init(_ equipments: [EquipmentFields]) {
        self.init(equipments.map(Equipment.init))
    }

    /// Returns all equipment types in this array.
    func allTypes() -> [EquipmentType] {
        let allTypes = self.compactMap(\.equipmentType)
        var uniqueTypes = [EquipmentType]()
        for eqType in allTypes where !uniqueTypes.contains(eqType) {
            uniqueTypes.append(eqType)
        }
        return uniqueTypes
    }

}

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

extension Array where Element == Giveaway {

    init(_ giveaways: [GiveawayFields]) {
        self.init(giveaways.map(Giveaway.init))
    }

}

extension Array where Element == Gym {

    /// Map an array of `GymFields` to an array of `Gym` objects.
    init(_ gyms: [GymFields]) {
        self.init(gyms.map(Gym.init))
    }

    /// Returns the facility given a unique name.
    func facilityWithName(name: String) -> Facility? {
        for gym in self {
            if let facility = gym.facilities.first(where: { $0.name == name }) {
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
        - currentTime: The current time to compare with and determine the status. Default is now.

     - Returns: A `Status` object based on its hours.
     */
    func getStatus(currentTime: Date = Date.now) -> Status? {
        // If facility is closed for an entire week
        if self.isEmpty { return .closed(openTime: .distantFuture) }

        // Remove dates in the past
        let filtered = self.sorted().filter { $0.endTime > currentTime }

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

    /**
     Retrieve hours that are in the given day of the week.

     - Parameters:
        - dayOfWeek: The day of the week.

     - Returns: An array of hours that are in that day of week.
     */
    func getHoursInDayOfWeek(dayOfWeek: DayOfWeek) -> [OpenHours] {
        self.filter { $0.startTime.getDayOfWeek() == dayOfWeek }
    }

}

extension Array where Element == User {

    init(_ users: [UserFields]) {
        self.init(users.map(User.init))
    }

}
