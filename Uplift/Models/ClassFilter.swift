//
//  ClassFilter.swift
//  Uplift
//
//  Created by Sandy Yang on 10/7/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

/// Model representing the filter options selected for fitness classes.
struct ClassFilter: Hashable {

    // MARK: - Properties

    /// The names of the fitenss centers selected. An empty set means all fitness centers. 
    var centers: Set<String> = []

    /// The earliest start time selected as an hour in 24-hour time.
    var startHour: Double = ClassFilter.defaultStartHour

    /// The latest end time selected as an hour in 24-hour time.
    var endHour: Double = ClassFilter.defaultEndHour

    /// The names of the class types selected. An empty set means all class types.
    var classTypes: Set<String> = []

    /// The names of the instructors selected. An empty set means all instructors
    var instructors: Set<String> = []

    /// Whether any filter option differs from the default.
    var isActive: Bool {
        self != .default
    }

    // MARK: - Constants

    /// The earliest hour a class can start.
    static let defaultStartHour: Double = 6

    /// The latest hour a class can end.
    static let defaultEndHour: Double = 22

    /// The range of hours the start time slider can select from.
    static let hourBounds: ClosedRange<Double> = defaultStartHour...defaultEndHour

    /// A filter with no options selected
    static let `default` = ClassFilter()

}
