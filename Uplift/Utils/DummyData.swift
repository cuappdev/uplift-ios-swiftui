//
//  DummyData.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Foundation
import UpliftAPI

/// Dummy data for the app's model objects.
struct DummyData {

    /// Default singleton instance
    static let `default` = DummyData()

    private init() { }

    // MARK: - Gym

    struct DummyGym {
        static let helenNewman: [String: Any] = [
            "__typename": "Gym",
            "id": "1",
            "description": "Helen Newman Description",
            "facilities": [
                [
                    "__typename": "Facility",
                    "id": "1",
                    "capacity": DummyData.DummyCapacity.lightCapacity,
                    "facilityType": "FITNESS",
                    "name": "Helen Newman",
                    "openHours": DummyData.DummyHours.weekdayAndWeekendHours
                ],
                [
                    "__typename": "Facility",
                    "id": "2",
                    "facilityType": "POOL",
                    "name": "Helen Newman Pool",
                    "openHours": DummyData.DummyHours.weekdayHours
                ]
            ],
            "imageUrl": "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg",
            "location": "163 Cradit Farm Road",
            "latitude": 42.453188923853595,
            "longitude": -76.47730907608567,
            "name": "Helen Newman"
        ]
    }

    // MARK: - Capacity

    struct DummyCapacity {
        /// Dummy light capacity for a facility.
        static let lightCapacity: [String: Any] = [
            "__typename": "Capacity",
            "count": 30,
            "percent": 0.20,
            "updated": "2023-11-21T22:50:00"
        ]

        /// Dummy cramped capacity for a facility.
        static let crampedCapacity: [String: Any] = [
            "__typename": "Capacity",
            "count": 50,
            "percent": 0.75,
            "updated": "2023-11-21T22:50:00"
        ]

        /// Dummy full capacity for a facility.
        static let fullCapacity: [String: Any] = [
            "__typename": "Capacity",
            "count": 80,
            "percent": 1,
            "updated": "2023-11-21T22:50:00"
        ]
    }

    // MARK: - Hours

    struct DummyHours {
        /// Dummy facility hours with weekdays only.
        static let weekdayHours: [[String: Any]] = [
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "07:30:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "08:55:00",
                "startTime": "07:45:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "11:45:00",
                "startTime": "11:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "14:00:00",
                "startTime": "12:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "07:55:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "11:30:00",
                "startTime": "10:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "14:00:00",
                "startTime": "12:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "07:30:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "08:55:00",
                "startTime": "07:45:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "11:45:00",
                "startTime": "11:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "14:00:00",
                "startTime": "12:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 3,
                "endTime": "07:55:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "08:00:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "10:30:00",
                "startTime": "08:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "13:30:00",
                "startTime": "11:30:00"
            ]
        ]

        /// Dummy facility hours with weekdays and weekends.
        static let weekdayAndWeekendHours: [[String: Any]] = [
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "07:30:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "08:55:00",
                "startTime": "07:45:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "11:45:00",
                "startTime": "11:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 0,
                "endTime": "14:00:00",
                "startTime": "12:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "07:55:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "11:30:00",
                "startTime": "10:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 1,
                "endTime": "14:00:00",
                "startTime": "12:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "07:30:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "08:55:00",
                "startTime": "07:45:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "11:45:00",
                "startTime": "11:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 2,
                "endTime": "14:00:00",
                "startTime": "12:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 3,
                "endTime": "07:55:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "08:00:00",
                "startTime": "06:00:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "10:30:00",
                "startTime": "08:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 4,
                "endTime": "13:30:00",
                "startTime": "11:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 5,
                "endTime": "13:30:00",
                "startTime": "11:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 5,
                "endTime": "17:30:00",
                "startTime": "14:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 6,
                "endTime": "13:30:00",
                "startTime": "11:30:00"
            ],
            [
                "__typename": "OpenHours",
                "day": 6,
                "endTime": "17:30:00",
                "startTime": "14:30:00"
            ]
        ]
    }

}

extension DummyData {

    /**
     Returns a `Gym` given a dummy data.

     - Parameters:
        - data: The dummy data to use.

     - Returns: the `Gym` object represented by the dummy data.
     */
    func getGym(data: [String: Any]) -> Gym! {
        do {
            let gymFields = try GymFields(data: data)
            return Gym(from: gymFields)
        } catch {
            #if DEBUG
            print("Error creating gym dummy data: \(error)")
            #endif
            return nil
        }
    }

}
