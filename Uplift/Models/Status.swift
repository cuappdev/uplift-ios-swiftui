//
//  Status.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

/// The status of the Gym or Facility.
enum Status: Hashable {

    /// Currently closed where `openTime` is the `Date` in which it will open next.
    case closed(openTime: Date)

    /// Currently open where `closeTime` is the `Date` in which it will begin closing.
    case open(closeTime: Date)

}
