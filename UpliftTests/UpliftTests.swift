//
//  UpliftTests.swift
//  UpliftTests
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import XCTest
@testable import Uplift

/// Test suite for Uplift.
final class UpliftTests: XCTestCase {

    /// Test procedure for retrieving `Gym` or `Facility` status.
    func testHourStatus() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mm a"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        var hours = DummyData.uplift.openHours.compactMap { DummyData.uplift.getOpenHours(data: $0) }

        // Currently closed, opens soon (exclusive)
        var current = formatter.date(from: "12/25/2023 10:00 AM")!
        var expected = Status.closed(openTime: hours[0].startTime)
        var result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)

        // Currently open, closes soon (inclusive)
        current = formatter.date(from: "12/25/2023 11:00 AM")!
        expected = Status.open(closeTime: hours[0].endTime)
        result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)

        // Currently open, closes soon (exclusive)
        current = formatter.date(from: "12/25/2023 12:30 PM")!
        expected = Status.open(closeTime: hours[0].endTime)
        result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)

        // Currently closed, opens tomorrow (inclusive)
        current = formatter.date(from: "12/25/2023 1:00 PM")!
        expected = Status.closed(openTime: hours[1].startTime)
        result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)

        // Currently closed, opens later today (exclusive)
        current = formatter.date(from: "12/26/2023 2:00 PM")!
        expected = Status.closed(openTime: hours[2].startTime)
        hours.removeFirst() // Remove this since there shouldn't be a time before today
        result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)

        // Currently closed, opens later today, with 3 in same day (exclusive)
        current = formatter.date(from: "12/26/2023 5:30 PM")!
        expected = Status.closed(openTime: hours[2].startTime)
        result = hours.getStatus(currentTime: current)
        XCTAssertEqual(expected, result)
    }

    /// Test procedure for computing next 7 days of `DayOfWeek`.
    func testNextSevenDays() {
        // No wrapping
        var expected: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        var result = DayOfWeek.sortedDaysOfWeek(start: .monday)
        XCTAssertEqual(expected, result)

        // Wrapping
        expected = [.wednesday, .thursday, .friday, .saturday, .sunday, .monday, .tuesday]
        result = DayOfWeek.sortedDaysOfWeek(start: .wednesday)
        XCTAssertEqual(expected, result)
    }

}
