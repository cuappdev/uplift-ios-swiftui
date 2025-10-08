//
//  Equipment.swift
//  Uplift
//
//  Created by Belle Hu on 2/25/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI
import SwiftUI

/// Model representing a facility's equipment.
struct Equipment: Hashable {

    // MARK: - Properties

    /// Accessibility for this equipment.
    let accessibility: AccessibilityType?

    /// The ID of the facility in which this equipment belongs to.
    let facilityId: Int

    /// The muscle groups of this equipment.
    let muscleGroup: [MuscleGroup]

    /// The name of this equipment.
    let name: String

    /// The amount of this equipment in the given facility,`nil` if it cannot be quantified.
    let quantity: Int?

    // MARK: - Functions

    /// Initializes this object given an `EquipmentFields` type.
    init(from equipment: EquipmentFields) {
        // Unwrap and convert GraphQL enum value to Swift enum value
        self.accessibility = equipment.accessibility?.value
        self.facilityId = equipment.facilityId
        self.muscleGroup = [MuscleGroup](equipment.muscleGroups.compactMap { $0?.value })
        self.name = equipment.name
        self.quantity = equipment.quantity
    }

}

extension MuscleGroup {

    public var description: String {
        switch self {
        case .abdominals:
            return "Abdominals"
        case .chest:
            return "Chest"
        case .back:
            return "Back"
        case .shoulders:
            return "Shoulder"
        case .biceps:
            return "Biceps"
        case .triceps:
            return "Triceps"
        case .hamstrings:
            return "Hamstrings"
        case .quads:
            return "Quads"
        case .glutes:
            return "Glutes"
        case .calves:
            return "Calves"
        case .miscellaneous:
            return "Miscellaneous"
        case .cardio:
            return "Cardio"
        }
    }

}

enum MuscleCategory: CaseIterable {

    case leg
    case arm
    case back
    case shoulder
    case chest
    case abdominals
    case miscellaneous

    var description: String {
        switch self {
        case .leg:
            return "LEG"
        case .arm:
            return "ARM"
        case .back:
            return "BACK"
        case .shoulder:
            return "SHOULDER"
        case .chest:
            return "CHEST"
        case .abdominals:
            return "ABDOMINALS"
        case .miscellaneous:
            return "MISCELLANOUS"
        }
    }

    var image: Image {
        switch self {
        case .leg:
            return Constants.Images.leg
        case .arm:
            return Constants.Images.arm
        case .back:
            return Constants.Images.back
        case .shoulder:
            return Constants.Images.shoulder
        case .chest:
            return Constants.Images.chest
        case .abdominals:
            return Constants.Images.abdominals
        case .miscellaneous:
            return Constants.Images.vertEllipsis
        }
    }

    var muscles: [MuscleGroup] {
        switch self {
        case .leg:
            return [.hamstrings, .quads, .glutes, .calves]
        case .arm:
            return [.biceps, .triceps]
        case .back:
            return [.back]
        case .shoulder:
            return [.shoulders]
        case .chest:
            return [.chest]
        case .abdominals:
            return [.abdominals]
        case .miscellaneous:
            return [.miscellaneous, .cardio]
        }
    }

}
