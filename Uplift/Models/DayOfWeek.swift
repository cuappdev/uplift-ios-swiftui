//
//  DayOfWeek.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

/// An enumeration representing the day of the week.
enum DayOfWeek: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

extension DayOfWeek {

    /// Returns the abbreviation for the day of the week.
    func dayOfWeekAbbreviation() -> String {
        switch self {
        case .sunday:
            return "Su"
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wednesday:
            return "W"
        case .thursday:
            return "Th"
        case .friday:
            return "F"
        case .saturday:
            return "Sa"
        }
    }

    /// Returns the shortened name for the day of the week.
    func dayOfWeekShortened() -> String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }

    /// Returns the complete name for the day of the week.
    func dayOfWeekComplete() -> String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }

    /**
     Returns an array of all days of the week sorted with the given day first.

     Once Sunday is reached, the array is wrapped around.

     - Parameters:
        - start: The starting day of the week. Default is today.

     - Returns: A sorted array of the days of the week.
     */
    static func sortedDaysOfWeek(start: DayOfWeek = Date.now.getDayOfWeek()) -> [DayOfWeek] {
        var result = [DayOfWeek]()
        for i in 0..<7 {
            var val = (start.rawValue + i) % 7
            if val == 0 { val = 7 }
            if let day = DayOfWeek(rawValue: val) {
                result.append(day)
            }
        }
        return result
    }

}
