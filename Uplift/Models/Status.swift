//
//  Status.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation

/// The status of the Gym or Facility.
enum Status: Hashable {

    /// Currently closed where `closeTime` is the `Date` in which it began closing.
    case closed(closeTime: Date)

    /// Currently open where `closeTime` is the `Date` in which it will begin closing.
    case open(closeTime: Date)

}
