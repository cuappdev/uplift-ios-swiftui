//
//  Equipment.swift
//  Uplift
//
//  Created by Belle Hu on 2/25/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a facility's equipment.
struct Equipment: Hashable {

    // MARK: - Properties

    /// Accessibility for this equipment.
    let accessibility: AccessibilityType?

    /// The type of this equipment.
    let equipmentType: EquipmentType

    /// The ID of the facility in which this equipment belongs to.
    let facilityId: Int

    /// The name of this equipment.
    let name: String

    /// The amount of this equipment in the given facility.
    let quantity: Int

    // MARK: - Functions

    /// Initializes this object given an `EquipmentFields` type.
    init(from equipment: EquipmentFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        self.accessibility = equipment.accessibility?.value

        if let equipmentType = EquipmentType(rawValue: equipment.equipmentType.rawValue) {
            self.equipmentType = equipmentType
        } else {
            self.equipmentType = EquipmentType.defaultEquipmentType
        }

        self.facilityId = equipment.facilityId
        self.name = equipment.name
        self.quantity = equipment.quantity ?? 0
    }

}

extension EquipmentType: CustomStringConvertible {

    static var defaultEquipmentType = EquipmentType(rawValue: "Miscellaneous")!

    public var description: String {
        switch self {
        case .cardio:
            return "Cardio Machines"
        case .freeWeights:
            return "Free Weights"
        case .miscellaneous:
            return "Miscellaneous"
        case .multiCable:
            return "Multiple Cables"
        case .plateLoaded:
            return "Plate Loaded Machines"
        case .racksAndBenches:
            return "Racks & Benches"
        case .selectorized:
            return "Precor Selectorized Machines"
        }
    }

}
