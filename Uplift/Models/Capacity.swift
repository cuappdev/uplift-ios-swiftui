//
//  Capacity.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//

import Foundation
import UpliftAPI

/// Model representing a facility's capacity.
struct Capacity: Hashable {

    // MARK: - Properties

    /// The number of people in this facility.
    let count: Int

    /// The percent filled between 0.0 and 1.0.
    let percent: Double

    /// The date in which this capacity was last updated.
    let updated: Date

    // MARK: - Functions

    /// Initializes this object given a `CapacityFields` type.
    init(from capacity: CapacityFields) {
        self.count = capacity.count
        self.percent = capacity.percent
        self.updated = Date(timeIntervalSince1970: TimeInterval(capacity.updated))
    }

}
