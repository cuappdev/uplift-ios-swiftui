//
//  String+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation

extension String {

    /**
     Returns the date for this string given a format and timezone.

     - Parameters:
        - format: The format of the string to decode from.
        - timezone: The abbreviation string of the timezone. Defaults to "EST".

     - Returns: A `Date` object of this string given the format and timezone.
     */
    func date(format: String, timezone: String = "EST") -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: timezone)
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }

}
