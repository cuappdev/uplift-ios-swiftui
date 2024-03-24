//
//  Facility.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI
import UpliftAPI

/// Model representing a facility.
struct Facility: Hashable {

    // MARK: - Properties

    /// The unique identifier of this facility.
    let id: String

    /// The current capacity of this facility.
    let capacity: Capacity?

    /// The equipments of this facility.
    let equipment: [Equipment]

    /// The type of this facility.
    let facilityType: FacilityType?

    /// The hours of this facility.
    let hours: [OpenHours]

    /// The name of this facility.
    let name: String

    /// The status of this facility.
    let status: Status?

    // MARK: - Functions

    /// Initializes this object given a `FacilityFields` type.
    init(from facility: FacilityFields) {
        self.id = facility.id

        if let capacityFields = facility.capacity?.fragments.capacityFields {
            self.capacity = Capacity(from: capacityFields)
        } else {
            self.capacity = nil
        }

        self.equipment = [Equipment](facility.equipment?.compactMap(\.?.fragments.equipmentFields) ?? [])
        self.facilityType = facility.facilityType.value
        self.hours = [OpenHours](facility.hours?.compactMap(\.?.fragments.openHoursFields) ?? [])
        self.name = facility.name
        self.status = self.hours.getStatus()
    }

}

extension FacilityType {

    /// The image for this facility type.
    var iconImage: Image {
        switch self {
        case .bowling:
            return Constants.Images.bowling
        case .court:
            return Constants.Images.basketball
        case .fitness:
            return Constants.Images.dumbbellLarge
        case .pool:
            return Constants.Images.pool
        }
    }

}
