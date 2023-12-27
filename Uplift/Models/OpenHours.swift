//
//  OpenHours.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a facility's open hours.
struct OpenHours: Comparable, Hashable {

    // MARK: - Properties

    /// The type of the court for these hours, if applicable.
    let courtType: CourtType?

    /// The closing time of these hours.
    let endTime: Date

    /// Whether the pool hours is shallow waters only.
    let isShallow: Bool?

    /// Whether the pool hours is women only.
    let isWomen: Bool?

    /// The opening time of these hours.
    let startTime: Date

    // MARK: - Functions

    /// Initializes this object given an `OpenHoursFields` type.
    init(from openHours: OpenHoursFields) {
        self.courtType = openHours.courtType?.value
        self.endTime = Date(timeIntervalSince1970: TimeInterval(openHours.endTime))
        self.isShallow = openHours.isShallow
        self.isWomen = openHours.isWomen
        self.startTime = Date(timeIntervalSince1970: TimeInterval(openHours.startTime))
    }

    /// Returns `true` if `lhs` has an earlier start time than `rhs`.
    static func < (lhs: OpenHours, rhs: OpenHours) -> Bool {
        lhs.startTime < rhs.startTime
    }

    /**
     Format these hours into a string representing open and close times.

     An example format is '6:00 AM - 9:00 PM'.

     - Returns: A formatted string containing open and close times.
     */
    func formatOpenCloseHours() -> String {
        let openString = self.startTime.timeStringTrailingZeros
        let closeString = self.endTime.timeStringTrailingZeros
        return "\(openString) - \(closeString)"
    }

}
