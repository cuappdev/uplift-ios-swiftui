//
//  Capacity.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a facility's capacity.
struct Capacity: Hashable {

    // MARK: - Properties

    /// The number of people in this facility.
    let count: Int

    /// The percent filled of this capacity.
    let percent: Double

    /// The status of this capacity.
    let status: CapacityStatus

    /// The date in which this capacity was last updated.
    let updated: Date

    // MARK: - Functions

    /// Initializes this object given a `CapacityFields` type.
    init(from capacity: CapacityFields) {
        self.count = capacity.count
        self.percent = capacity.percent

        if capacity.percent < 0.5 {
            self.status = .light(capacity.percent)
        } else if capacity.percent < 0.8 {
            self.status = .cramped(capacity.percent)
        } else {
            self.status = .full(capacity.percent)
        }

        self.updated = Date(timeIntervalSince1970: TimeInterval(capacity.updated))
    }

}

/// An enumeration of the status of the current capacity.
enum CapacityStatus: Hashable {

    /// The percent is between 0.0 and 0.5.
    case light(Double)

    /// The percent is between 0.5 and 0.8.
    case cramped(Double)

    /// The percent is between 0.8 and 1.0.
    case full(Double)

}
