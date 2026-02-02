//
//  HourlyAverageCapacity.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/23/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation

struct HourlyAverageCapacity: Hashable {
    let averagePercent: Double
    let dayOfWeek: String
    let hourOfDay: Int
}
