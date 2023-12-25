//
//  Facility.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
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

    /// The hours of this facility.
    let hours: [OpenHours]

    /// The name of this facility.
    let name: String

    // MARK: - Functions

    /// Initializes this object given a `FacilityFields` type.
    init(from facility: FacilityFields) {
        self.id = facility.id

        if let capacityFields = facility.capacity?.fragments.capacityFields {
            self.capacity = Capacity(from: capacityFields)
        } else {
            self.capacity = nil
        }

        self.facilityType = facility.facilityType.value
        self.hours = [OpenHours](facility.hours?.compactMap(\.?.fragments.openHoursFields) ?? [])
        self.name = facility.name
    }

}
