//
//  Date+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//

import Foundation

extension Date {

    /**
     This `Date` in the format "h:mm a".
     For example, 12/25/23 8:00 PM is 8:00 PM.
     */
    var timeStringTrailingZeros: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }

    /**
     This `Date` in the format "h:mm a" with trailing 00 removed.
     For example, 8:00 PM is 8 PM.
     */
    var timeStringNoTrailingZeros: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        // Remove trailing 00
        let formatted = formatter.string(from: self)
        if formatted.hasSuffix("00 AM") || formatted.hasSuffix("00 PM"),
           let colonPos = formatted.firstIndex(of: ":"),
           let spacePos = formatted.firstIndex(of: " ") {

            let first = formatted[..<colonPos]
            let last = formatted[formatted.index(spacePos, offsetBy: 0)...]
            return String(first + last)
        }

        return formatted
    }

    /// Returns the `DayOfWeek` for this date.
    func getDayOfWeek() -> DayOfWeek {
        DayOfWeek(rawValue: Calendar.current.dateComponents([.weekday], from: self).weekday!)!
    }

}
