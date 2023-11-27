//
//  Date+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation

extension Date {

    /**
     The day number of the week for this `Date` starting with Monday as 0.

     For example, Monday is 0, Tuesday is 1, ... , Sunday is 6.
     */
    var dayNumberOfWeek: Int {
        // An integer from 1 to 7, with 1 being Sunday and 7 being Saturday
        let num = Calendar.current.dateComponents([.weekday], from: self).weekday!

        switch num {
        case 1:
            return 6 // Sunday
        case 2:
            return 0 // Monday
        case 3:
            return 1 // Tuesday
        case 4:
            return 2 // Wednesday
        case 5:
            return 3 // Thursday
        case 6:
            return 4 // Friday
        case 7:
            return 5 // Saturday
        default:
            return -1 // Will never happen
        }
    }

    /**
     This `Date` in the format "h:mm a" with trailing 00 removed.

     For example, 8:00PM is 8PM.
     */
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        // Remove trailing 00
        let formatted = formatter.string(from: self)
        if formatted.hasSuffix("00 AM") || formatted.hasSuffix("00 PM"),
           let colonPos = formatted.firstIndex(of: ":"),
           let spacePos = formatted.firstIndex(of: " ") {

            let first = formatted[..<colonPos]
            let last = formatted[formatted.index(spacePos, offsetBy: 1)...]
            return String(first + last)
        }

        return formatted
    }

    /**
     Determine if this `Date`'s time portion is less than the passed in `Date`.

     - Parameters:
        - other: The other `Date` to compare with this one.
        - timezone: The timezone abrreviation to offset. Defaults to "EST".

     - Returns: `true` if less and `false` otherwise.
     */
    func timeLessThan(other: Date, timezone: String = "EST") -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: timezone)!

        // Initiates date at 2001-01-01 00:00:00 +0000
        var selfDate = Date(timeIntervalSinceReferenceDate: 0)
        var otherDate = Date(timeIntervalSinceReferenceDate: 0)

        // Receive the components from the dates you want to compare
        let selfDateComponents = calendar.dateComponents([.hour, .minute], from: self)
        let otherDateComponents = calendar.dateComponents([.hour, .minute], from: other)

        // Add those components
        selfDate = calendar.date(byAdding: selfDateComponents, to: selfDate)!
        otherDate = calendar.date(byAdding: otherDateComponents, to: otherDate)!

        return selfDate < otherDate
    }

}
