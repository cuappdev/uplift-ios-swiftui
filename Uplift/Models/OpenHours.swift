//
//  OpenHours.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation
import UpliftAPI

/// Model representing a facility's open hours.
struct OpenHours: Hashable {

    // MARK: - Properties

    /// The day of the week with 0 for Monday, 1 for Tuesday, ... , 6 for Sunday.
    let day: Int

    /// The closing time of these hours.
    let endTime: Date

    /// The opening time of these hours.
    let startTime: Date

    // MARK: - init

    /// Initializes this object given an `OpenHoursFields` type.
    init(from openHours: OpenHoursFields) {
        self.day = openHours.day
        self.endTime = openHours.endTime?.date(format: "HH:mm:ss", timezone: "EST") ?? Date()
        self.startTime = openHours.startTime?.date(format: "HH:mm:ss", timezone: "EST") ?? Date()
    }

}

extension Array where Element == OpenHours {

    /// Map an array of `OpenHoursFields` to an array of `OpenHours` objects.
    init(_ openHours: [OpenHoursFields]) {
        self.init(openHours.map(OpenHours.init))
    }

}
