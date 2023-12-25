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

    /// Singleton instance.
    static let uplift = DummyData()

    private init() { }

    // MARK: - Functions

    /**
     Returns a `Gym` given a dummy data.

     - Parameters:
     - data: The dummy data to use.

     - Returns: The `Gym` object represented by the dummy data.
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

    /**
     Returns an `OpenHours` object given a dummy data.

     - Parameters:
     - data: The dummy data to use.

     - Returns: The `OpenHours` object represented by the dummy data.
     */
    func getOpenHours(data: [String: Any]) -> OpenHours! {
        do {
            let openHoursFields = try OpenHoursFields(data: data)
            return OpenHours(from: openHoursFields)
        } catch {
#if DEBUG
            print("Error creating open hours dummy data: \(error)")
#endif
            return nil
        }
    }

    // MARK: - Data

    /// Dummy data for Helen Newman.
    let helenNewman: [String: Any] = [
        "__typename": "Gym",
        "id": "1",
        "address": "163 Cradit Farm Road",
        "amenities": [
            [
                "__typename": "Amenity",
                "type": "SHOWERS"
            ],
            [
                "__typename": "Amenity",
                "type": "LOCKERS"
            ],
            [
                "__typename": "Amenity",
                "type": "PARKING"
            ],
            [
                "__typename": "Amenity",
                "type": "ELEVATORS"
            ]
        ],
        "facilities": [
            [
                "__typename": "Facility",
                "id": "1",
                "capacity": [
                    "__typename": "Capacity",
                    "count": 0,
                    "percent": 0.0,
                    "updated": 1702940040
                ],
                "facilityType": "FITNESS",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703466000,
                        "startTime": 1703430000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703556000,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703642400,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703728800,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703815200,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703901600,
                        "startTime": 1703847600
                    ]
                ],
                "name": "Fitness Center"
            ],
            [
                "__typename": "Facility",
                "id": "2",
                "facilityType": "POOL",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703507400,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703512500,
                        "startTime": 1703508300
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703522700,
                        "isWomen": true,
                        "startTime": 1703520000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703530800,
                        "startTime": 1703523600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703595300,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703608200,
                        "startTime": 1703602800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703617200,
                        "startTime": 1703611800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703680200,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703685300,
                        "startTime": 1703681100
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703695500,
                        "isWomen": true,
                        "startTime": 1703692800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703703600,
                        "startTime": 1703696400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703768100,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703854800,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703867400,
                        "startTime": 1703856600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703872800,
                        "startTime": 1703869200
                    ]
                ],
                "name": "Swimming Pool"
            ],
            [
                "__typename": "Facility",
                "id": "3",
                "facilityType": "BOWLING",
                "hours": [],
                "name": "Bowling"
            ],
            [
                "__typename": "Facility",
                "id": "4",
                "capacity": [
                    "__typename": "Capacity",
                    "count": 0,
                    "percent": 0.0,
                    "updated": 1703114640
                ],
                "facilityType": "COURT",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703475000,
                        "startTime": 1703439000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703514600,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703561400,
                        "startTime": 1703521800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703598300,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703647800,
                        "startTime": 1703633400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703687400,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703734200,
                        "startTime": 1703694600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703771100,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703820600,
                        "startTime": 1703792700
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703860200,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703903400,
                        "startTime": 1703876400
                    ]
                ],
                "name": "Court 1"
            ],
            [
                "__typename": "Facility",
                "id": "5",
                "capacity": [
                    "__typename": "Capacity",
                    "count": 0,
                    "percent": 0.0,
                    "updated": 1703114640
                ],
                "facilityType": "COURT",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703475000,
                        "startTime": 1703439000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703514600,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703561400,
                        "startTime": 1703521800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703598300,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703647800,
                        "startTime": 1703633400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703687400,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703734200,
                        "startTime": 1703694600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703771100,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703820600,
                        "startTime": 1703792700
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703860200,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703903400,
                        "startTime": 1703876400
                    ]
                ],
                "name": "Court 2"
            ]
        ],
        "hours": [
            [
                "__typename": "OpenHours",
                "endTime": 1703476800,
                "startTime": 1703430000
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703563200,
                "startTime": 1703502000
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703649600,
                "startTime": 1703588400
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703736000,
                "startTime": 1703674800
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703822400,
                "startTime": 1703761200
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703905200,
                "startTime": 1703847600
            ]
        ],
        "imageUrl": "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg",
        "latitude": 42.453188923853595,
        "longitude": -76.47730907608567,
        "name": "Helen Newman"
    ]

    /// Dummy data for open hours.
    let openHours: [[String: Any]] = [
        [
            "__typename": "OpenHours",
            "endTime": 1703509200, // Mon Dec 25 2023 13:00 UTC
            "startTime": 1703502000 // Mon Dec 25 2023 11:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703595600, // Tue Dec 26 2023 13:00 UTC
            "startTime": 1703588400 // Tue Dec 26 2023 11:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703610000, // Tue Dec 26 2023 17:00 UTC
            "startTime": 1703602800 // Tue Dec 26 2023 15:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703617200, // Tue Dec 26 2023 19:00 UTC
            "startTime": 1703613600 // Tue Dec 26 2023 18:00 UTC
        ]
    ]

}
