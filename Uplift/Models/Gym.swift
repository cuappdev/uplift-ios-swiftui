//
//  Gym.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Foundation
import UpliftAPI

/// Model representing a gym.
struct Gym: Hashable {

    // MARK: - Properties

    /// This gym's unique identifier.
    let id: String

    /// This gym's description.
    let description: String

    /// This gym's facilities.
    let facilities: [Facility]

    /// The URL of the image of this gym.
    let imageUrl: URL?

    /// The location where this gym is located.
    let location: String

    /// The latitude coordinate of this gym.
    let latitude: Double

    /// The longitude coordinate of this gym.
    let longitude: Double

    /// The name of this gym.
    let name: String

    /// The status of this gym.
    let status: Status

    // MARK: - init

    /// Initializes this object given a `GymFields` type.
    init(from gym: GymFields) {
        self.id = gym.id
        self.description = gym.description
        self.imageUrl = {
            guard let stringUrl = gym.imageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.location = gym.location
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.name = gym.name

        let facilities = [Facility](gym.facilities?.compactMap(\.?.fragments.facilityFields) ?? [])
        self.facilities = facilities

        self.status = {
            let lastHours: [Date] = facilities.map { facility in
                let todayHours = facility.openHours.filter {
                    // Filter hours that belong to today
                    $0.day == Date.now.dayNumberOfWeek
                }

                // Get the last hour for today in this facility. Ignores empty arrays.
                return todayHours.map(\.endTime).max() ?? Date.distantPast
            }

            // Get the last hour from all facilities
            if let closingTime = lastHours.max() {
                // Compare with current time's hours and minutes
                if closingTime.timeLessThan(other: Date.now) {
                    return .closed(closeTime: closingTime)
                } else {
                    return .open(closeTime: closingTime)
                }
            } else {
                // Should never happen
                return .closed(closeTime: Date.distantPast)
            }
        }()
    }

}

extension Array where Element == Gym {

    /// Map an array of `GymFields` to an array of `Gym` objects.
    init(_ gyms: [GymFields]) {
        self.init(gyms.map(Gym.init))
    }

}
