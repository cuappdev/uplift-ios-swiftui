//
//  Date+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension Date {

    /**
     This `Date` in the format "MM/dd h:mm a".
     For example, 12/25/23 8:00 PM is 12/25 8:00 PM.
     */
    var dateStringTrailingZeros: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd h:mm a"
        return formatter.string(from: self)
    }

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

    /**
     This `Date` in the format "ha".
     For example, 8:00 PM is 8PM.
     */
    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }

    /**
     This `Date` in the format "EEEE, MMMM dd".
     For example, 4/29/24 8:00 PM is Monday, April 29.
     */
    var dateStringDayMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: self)
    }

    /// Returns the `DayOfWeek` for this date.
    func getDayOfWeek() -> DayOfWeek {
        DayOfWeek(rawValue: Calendar.current.dateComponents([.weekday], from: self).weekday!)!
    }

    /// Returns whether this date is the same day as the given date.
    func isSameDay(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let thisDate = calendar.dateComponents([.year, .month, .day], from: self)
        let otherDate = calendar.dateComponents([.year, .month, .day], from: date)
        return thisDate.month == otherDate.month && thisDate.day == otherDate.day
    }

}
