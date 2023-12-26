//
//  DayOfWeek.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
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
            return "Sun"
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
            return "Sat"
        }
    }

    /// Returns an array of all days of the week sorted with today first.
    static func sortedDaysOfWeek() -> [DayOfWeek] {
        // Determine current day
        let today = Date.now.getDayOfWeek()

        var result = [DayOfWeek]()
        for i in 0..<7 {
            var val = (today.rawValue + i) % 7
            if val == 0 { val = 7 }
            if let day = DayOfWeek(rawValue: val) {
                result.append(DayOfWeek(rawValue: val) ?? .monday)
            }
        }
        return result
    }

}
