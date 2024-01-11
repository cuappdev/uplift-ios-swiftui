//
//  AnalyticsManager.swift
//  Uplift
//
//  Created by Vin Bui on 1/10/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import FirebaseAnalytics
import OSLog

/// Manage Uplift's Google Analytics.
class AnalyticsManager {

    /// Shared singleton instance.
    static let shared = AnalyticsManager()

    private init() {}

    /// Log an event to Google Analytics.
    func log(_ event: Event) {
        #if !DEBUG
        Analytics.logEvent(event.name, parameters: event.parameters)
        #else
        Logger.statistics.info("[DEBUG] Logged event: \(event.name), params: \(event.parameters?.description ?? "nil")")
        #endif
    }

}

/// A structure that represents a Google Analytics event.
struct Event {

    /// The name of the event.
    let name: String

    /// The parameters to pass in to this event.
    let parameters: [String: Any]?

}

/// An enumeration representing an Uplift event.
enum UpliftEvent: String {

    // MARK: - Home Page Events

    /// Taps on the button to expand facility information.
    case expandFacilityView = "expand_facility_view"

    /// Taps on the button to view fitness center hours.
    case expandFitnessHours = "expand_fitness_hours"

    /// Taps on a the button to toggle capacities into view on the home page.
    case tapCapacityToggle = "tap_capacity_toggle"

    /// Taps on a gym cell on the home page.
    case tapGymCell = "tap_gym_cell"

    /// Taps on the "View Hours" button to view building hours.
    case tapViewHoursGym = "tap_view_hours_gym"

    // MARK: - Helpers

    /// An enumeration representing the type of event.
    enum EventType {
        case facility
        case gym
    }

    /**
     Retrieve an `Event` object for this custom event.

     Do not pass in any parameters to this function if no parameters are tracked for this event.

     - Parameters:
        - type: The type of the event to track used as the parameter key.
        - value: The value for the parameter key.

     - Returns: An `Event` to be tracked in Google Analytics.
     */
    func toEvent(type: EventType? = nil, value: String? = nil) -> Event {
        // No Parameters
        guard let type,
              let value else { return Event(name: rawValue, parameters: nil) }

        // With Parameters
        var parameters: [String: Any]
        switch type {
        case .facility:
            parameters = ["facilityName": value]
        case .gym:
            parameters = ["gymName": value]
        }
        return Event(name: rawValue, parameters: parameters)
    }

}
