//
//  Logger.swift
//  Uplift
//
//  Created by Vin Bui on 12/28/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import OSLog

/// Manage Uplift's logging system.
extension Logger {

    /// The logger's subsystem.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// All logs related to data such as decoding error, parsing issues, etc.
    static let data = Logger(subsystem: subsystem, category: "data")

    /// All logs related to services such as network calls, location, etc.
    static let services = Logger(subsystem: subsystem, category: "services")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

}
