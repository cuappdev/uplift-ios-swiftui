//
//  Capacity.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation
import UpliftAPI

/// Model representing a facility's capacity.
struct Capacity: Hashable {

    // MARK: - Properties

    /// The amount of people currently in the facility.
    let count: Int

    /// The percent of the current capacity with respect to the the max capacity.
    let percent: Double

    /// The date in which this capacity was last updated.
    let updated: Date

    // MARK: - init

    /// Initializes this object given a `CapacityFields` type.
    init(from capacity: CapacityFields) {
        self.count = capacity.count
        self.percent = capacity.percent
        self.updated = capacity.updated.date(format: "yyyy-MM-dd'T'HH:mm:ss", timezone: "EST")
    }

}
