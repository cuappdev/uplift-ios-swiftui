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
    
    /// Initializes this object given a `EquipmentFields` type.
    init(from equipment: EquipmentFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        if let graphQLEnum = equipment.accessibility {
            self.accessibility = AccessibilityType(rawValue: graphQLEnum.rawValue) ?? nil
        } else {
            self.accessibility = nil
        }
//        
//        if let accessibility = equipment.accessibility?.rawValue {
//            self.accessibility = AccessibilityType(rawValue: accessibility)
//        } else {
//            self.accessibility = nil
//        }
        
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
    
    /// This equipment includes machines that are plate loaded, such as the sled leg press, plate-loaded chest press, etc.
    case plateLoaded
    
    /// This equipment contains racks and benches for exercises such as squats, bench press, etc.
    case racksAndBenches
    
    /// This equipment allows the user to change the selected weight with a pin.
    case selectorized
    
    /// Default initializer to handle unknown values
    init?(rawValue: String) {
        switch rawValue {
        case "cardio", "freeWeights", "miscellaneous", "multiCable", "plateLoaded", "racksAndBenches", "selectorized":
            self = EquipmentType(rawValue: rawValue)!
        default:
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
