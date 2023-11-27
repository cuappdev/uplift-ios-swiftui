//
//  Facility.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation
import UpliftAPI

/// Model representing a facility.
struct Facility: Hashable {

    // MARK: - Properties

    /// The unique identifier of this facility.
    let id: String

    /// The current capacity of this facility.
    let capacity: Capacity?

    /// The type of this facility.
    let facilityType: FacilityType?

    /// The name of this facility.
    let name: String

    /// The open hours of this facility.
    let openHours: [OpenHours]

    // MARK: - init

    /// Initializes this object given a `FacilityFields` type.
    init(from facility: FacilityFields) {
        self.id = facility.id

        if let capacityFields = facility.capacity?.fragments.capacityFields {
            self.capacity = Capacity(from: capacityFields)
        } else {
            self.capacity = nil
        }

        self.facilityType = FacilityType(rawValue: facility.facilityType.rawValue)
        self.name = facility.name
        self.openHours = [OpenHours](facility.openHours?.compactMap(\.?.fragments.openHoursFields) ?? [])
    }

}

/// The type of a facility.
enum FacilityType: String {
    case fitness = "FITNESS"
    case pool = "POOL"
}

extension Array where Element == Facility {

    /// Map an array of `FacilityFields` to an array of `Facility` objects.
    init(_ facilities: [FacilityFields]) {
        self.init(facilities.map(Facility.init))
    }

}
