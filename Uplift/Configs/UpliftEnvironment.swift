//
//  UpliftEnvironment.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

/// Data from Info.plist stored as environment variables.
enum UpliftEnvironment {

    /// Keys from Info.plist.
    enum Keys {
#if DEBUG
        static let baseURL: String = "DEV_URL"
#else
        static let baseURL: String = "PROD_URL"
#endif
        static let announcementsCommonPath = "ANNOUNCEMENTS_COMMON_PATH"
        static let announcementsHost = "ANNOUNCEMENTS_HOST"
        static let announcementsPath = "ANNOUNCEMENTS_PATH"
        static let announcementsScheme = "ANNOUNCEMENTS_SCHEME"
    }

    /// A dictionary storing key-value pairs from Info.plist.
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dict
    }()

    /**
     The base URL of Uplift's backend server.

     * If the scheme is set to DEBUG, the development server URL is used.
     * If the scheme is set to RELEASE, the production server URL is used.
     */
    static let baseURL: URL = {
        guard let baseURLString = UpliftEnvironment.infoDict[Keys.baseURL] as? String,
              let baseURL = URL(string: baseURLString) else {
#if DEBUG
            fatalError("DEV_URL not found in Info.plist")
#else
            fatalError("PROD_URL not found in Info.plist")
#endif
        }
        return baseURL
    }()

    /// The common path for AppDev Announcements.
    static let announcementsCommonPath: String = {
        guard let value = UpliftEnvironment.infoDict[Keys.announcementsCommonPath] as? String else {
            fatalError("ANNOUNCEMENTS_COMMON_PATH not found in Info.plist")
        }
        return value
    }()

    /// The host AppDev Announcements.
    static let announcementsHost: String = {
        guard let value = UpliftEnvironment.infoDict[Keys.announcementsHost] as? String else {
            fatalError("ANNOUNCEMENTS_HOST not found in Info.plist")
        }
        return value
    }()

    /// The path for AppDev Announcements.
    static let announcementsPath: String = {
        guard let value = UpliftEnvironment.infoDict[Keys.announcementsPath] as? String else {
            fatalError("ANNOUNCEMENTS_PATH not found in Info.plist")
        }
        return value
    }()

    /// The scheme for AppDev Announcements.
    static let announcementsScheme: String = {
        guard let value = UpliftEnvironment.infoDict[Keys.announcementsScheme] as? String else {
            fatalError("ANNOUNCEMENTS_SCHEME not found in Info.plist")
        }
        return value
    }()

}
