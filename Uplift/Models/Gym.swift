//
//  Gym.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//

import Foundation
import UpliftAPI

/// Model representing a gym.
struct Gym: Hashable {

    // MARK: - Properties

    /// The ID of this gym (building).
    let id: String

    /// The address of the building.
    let address: String

    /// This gym's amenities.
    let amenities: [AmenityType]

    /// This gym's facilities.
    let facilities: [Facility]

    /// This gym's fitness centers.
    var fitnessCenters: [Facility] {
        facilities.filter { $0.facilityType == .fitness }
    }

    /// This gym's building hours.
    let hours: [OpenHours]

    /// The URL of the image of this gym.
    let imageUrl: URL?

    /// The latitude coordinate of this gym.
    let latitude: Double

    /// The longitude coordinate of this gym.
    let longitude: Double

    /// The name of this gym.
    let name: String

    /// The status of this gym.
    let status: Status?

    // MARK: - Functions

    /// Initializes this object given a `GymFields` type.
    init(from gym: GymFields) {
        self.id = gym.id
        self.address = gym.address
        self.amenities = gym.amenities?.compactMap(\.?.type.value) ?? []
        self.facilities = [Facility](gym.facilities?.compactMap(\.?.fragments.facilityFields) ?? [])
        self.hours = [OpenHours](gym.hours?.compactMap(\.?.fragments.openHoursFields) ?? [])
        self.imageUrl = {
            guard let stringUrl = gym.imageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.name = gym.name
        self.status = self.hours.getStatus()
    }

    /// Returns the highest capacity fitness center for this gym (Teagle).
    func highestCapacityFC() -> Facility? {
        let defaultPercent = Double.leastNormalMagnitude
        return fitnessCenters.max {
            $0.capacity?.percent ?? defaultPercent > $1.capacity?.percent ?? defaultPercent
        }
    }

    /// Returns the facility given an ID.
    func facilityWithID(id: String) -> Facility? {
        facilities.first { $0.id == id }
    }

}
