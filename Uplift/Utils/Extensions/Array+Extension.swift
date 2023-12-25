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

}

extension Array where Element == Gym {

    /// Map an array of `GymFields` to an array of `Gym` objects.
    init(_ gyms: [GymFields]) {
        self.init(gyms.map(Gym.init))
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
        // Get earliest dates
        guard let earliest = self.min() else { return nil }
        let earliestRemoved = self.filter { $0 != earliest }
        guard let secondEarliest = earliestRemoved.min() else { return nil }

        if currentTime < earliest.startTime {
            // Not open yet
            return .closed(openTime: earliest.startTime)
        } else if currentTime >= earliest.startTime && currentTime < earliest.endTime {
            // Currently open, closing soon
            return .open(closeTime: earliest.endTime)
        } else {
            // Current closed
            return .closed(openTime: secondEarliest.startTime)
        }
    }

}
