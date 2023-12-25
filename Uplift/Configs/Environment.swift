//
//  Environment.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Foundation

/// Data from Info.plist stored as environment variables.
enum Environment {

    /// Keys from Info.plist.
    enum Keys {
#if DEBUG
        static let baseURL: String = "DEV_URL"
#else
        static let baseURL: String = "PROD_URL"
#endif
    }

    /// A dictionary storing key-value pairs from IDs.plist.
    static let idsDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "IDs", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) else {
            fatalError("IDs.plist not found")
        }
        return dict
    }()

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
        guard let baseURLString = Environment.infoDict[Keys.baseURL] as? String,
              let baseURL = URL(string: baseURLString) else {
            fatalError("Base URL not found in Info.plist")
        }
        return baseURL
    }()

}
