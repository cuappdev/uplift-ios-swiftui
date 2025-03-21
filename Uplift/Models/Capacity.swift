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
            self.status = .notBusy(capacity.percent)
        } else if capacity.percent < 0.8 {
            self.status = .slightlyBusy(capacity.percent)
        } else {
            self.status = .veryBusy(capacity.percent)
        }

        self.updated = Date(timeIntervalSince1970: TimeInterval(capacity.updated))
    }

}

/// An enumeration of the status of the current capacity.
enum CapacityStatus: Hashable {

    /// The percent is between 0.0 and 0.5.
    case notBusy(Double)

    /// The percent is between 0.5 and 0.8.
    case slightlyBusy(Double)

    /// The percent is between 0.8 and 1.0.
    case veryBusy(Double)

}

/// An enumeration of the status message of the current capacity.
enum CapacityText: String {
    case notBusy = "Not Busy"
    case slightlyBusy = "Slightly Busy"
    case veryBusy = "Very Busy"
}
