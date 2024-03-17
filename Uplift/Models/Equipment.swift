//
//  Equipment.swift
//  Uplift
//
//  Created by Belle Hu on 2/25/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI
import UpliftAPI

/// Model representing a facility's equipments
struct Equipment: Hashable {
    // MARK: - Properties

    /// The ID of this equipment.
    let accessibility: AccessibilityType?

    /// The type of this equipment.
    let equipmentType: EquipmentType!

    /// The ID of the facility in which this equipment belongs to.
    let facilityId: Int

    /// The name of this equipment.
    let name: String

    /// The amount of this equipment in the given facility.
    let quantity: Int?

    // MARK: - Functions
    init(accessibility: AccessibilityType, eqType: EquipmentType?, fcId: Int, name: String, quant: Int) {
        self.accessibility = accessibility
        self.equipmentType = eqType
        self.facilityId = fcId
        self.name = name
        self.quantity = quant
    }

    /// Initializes this object given a `EquipmentFields` type.
    init(from equipment: EquipmentFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        if let graphQLEnum = equipment.accessibility {
            self.accessibility = AccessibilityType(rawValue: graphQLEnum.rawValue) ?? nil
        } else {
            self.accessibility = nil
        }

        self.equipmentType = EquipmentType(rawValue: equipment.equipmentType.rawValue)

        self.facilityId = equipment.facilityId
        self.name = equipment.name
        self.quantity = equipment.quantity
    }
}

//  The type of this equipment.
enum EquipmentType {

    /// This equipment is used for cardio, such as treadmills, ellipticals, etc.
    case cardio

    /// This equipment includes weights that are not attached and can freely move such as dumbbells and barbells.
    case freeWeights

    /// This equipment is not classified in any category, such as stretch bands, stability balls, etc.
    case miscellaneous

    /// This equipment contains multiple cables for exercises such as cable chest flys.
    case multiCable

    /// This equipment includes machines that are plate loaded, such as the sled leg press,
    /// plate-loaded chest press, etc.
    case plateLoaded

    /// This equipment contains racks and benches for exercises such as squats, bench press, etc.
    case racksAndBenches

    /// This equipment allows the user to change the selected weight with a pin.
    case selectorized
//
//    init?(rawValue: String) {
//        switch rawValue {
//        case "cardio", "freeWeights", "miscellaneous", "multiCable", "plateLoaded", "racksAndBenches", "selectorized":
//            if let equipmentType = EquipmentType(rawValue: rawValue) {
//                self = equipmentType
//            } else {
//                print("UNABLE TO CONVERT")
//                return nil
//            }
//        default:
//            return nil
//        }
//    }

    init?(rawValue: String) {
        if rawValue == "CARDIO" {
            self = .cardio
        } else if rawValue == "FREE_WEIGHTS" {
            self = .freeWeights
        } else if rawValue == "MISCELLANEOUS" {
            self = .miscellaneous
        } else if rawValue == "MULTI_CABLE" {
            self = .multiCable
        } else if rawValue == "PLATE_LOADED" {
            self = .plateLoaded
        } else if rawValue == "RACKS_AND_BENCHES" {
            self = .racksAndBenches
        } else if rawValue == "SELECTORIZED" {
            self = .selectorized
        } else {
            return nil
        }
    }
}

// Accessibility for this equipment.
enum AccessibilityType {

    /// This equipment is wheelchair accessible.
    case wheelchair

    /// Default initializer to handle unknown values
    init?(rawValue: String) {
        switch rawValue {
        case "wheelchair":
            self = .wheelchair
        default:
            return nil
        }
    }
}

extension Equipment {
    static var dummyData = [
        Equipment(
            accessibility: AccessibilityType.wheelchair,
            eqType: EquipmentType.selectorized,
            fcId: 1,
            name: "Stuff",
            quant: 10
        ),
        Equipment(
            accessibility: AccessibilityType.wheelchair,
            eqType: EquipmentType.selectorized,
            fcId: 1,
            name: "Stuff part 2",
            quant: 5
        ),
        Equipment(
            accessibility: AccessibilityType.wheelchair,
            eqType: EquipmentType.cardio,
            fcId: 1,
            name: "Running machines",
            quant: 20
        )
    ]
}

extension EquipmentType {
    static var allEquipmentTypes = [
        EquipmentType.cardio,
        EquipmentType.freeWeights,
        EquipmentType.miscellaneous,
        EquipmentType.multiCable,
        EquipmentType.plateLoaded,
        EquipmentType.racksAndBenches,
        EquipmentType.selectorized
    ]
}
