//
//  DummyData.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
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
            Logger.data.error("Error creating gym dummy data: \(error)")
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
            Logger.data.error("Error creating open hours dummy data: \(error)")
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
                        "isSpecial": false,
                        "startTime": 1703430000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703556000,
                        "isSpecial": false,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703642400,
                        "isSpecial": false,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703728800,
                        "isSpecial": false,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703815200,
                        "isSpecial": false,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703901600,
                        "isSpecial": false,
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
                        "isSpecial": false,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703512500,
                        "isSpecial": false,
                        "startTime": 1703508300
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703522700,
                        "isSpecial": false,
                        "isWomen": true,
                        "startTime": 1703520000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703530800,
                        "isSpecial": false,
                        "startTime": 1703523600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703595300,
                        "isSpecial": false,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703608200,
                        "isSpecial": false,
                        "startTime": 1703602800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703617200,
                        "isSpecial": false,
                        "startTime": 1703611800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703680200,
                        "isSpecial": false,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703685300,
                        "isSpecial": false,
                        "startTime": 1703681100
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703695500,
                        "isSpecial": false,
                        "isWomen": true,
                        "startTime": 1703692800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703703600,
                        "isSpecial": false,
                        "startTime": 1703696400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703768100,
                        "isSpecial": false,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703854800,
                        "isSpecial": false,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703867400,
                        "isSpecial": false,
                        "startTime": 1703856600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1703872800,
                        "isSpecial": false,
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
                        "isSpecial": false,
                        "startTime": 1703439000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703514600,
                        "isSpecial": false,
                        "startTime": 1703502000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703561400,
                        "isSpecial": false,
                        "startTime": 1703521800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703598300,
                        "isSpecial": false,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703647800,
                        "isSpecial": false,
                        "startTime": 1703633400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703687400,
                        "isSpecial": false,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703734200,
                        "isSpecial": false,
                        "startTime": 1703694600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703771100,
                        "isSpecial": false,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703820600,
                        "isSpecial": false,
                        "startTime": 1703792700
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703860200,
                        "isSpecial": false,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BASKETBALL",
                        "endTime": 1703903400,
                        "isSpecial": false,
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
                        "isSpecial": false,
                        "startTime": 1703439000
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703514600,
                        "isSpecial": false,
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
                        "isSpecial": false,
                        "startTime": 1703588400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703647800,
                        "isSpecial": false,
                        "startTime": 1703633400
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703687400,
                        "isSpecial": false,
                        "startTime": 1703674800
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "VOLLEYBALL",
                        "endTime": 1703734200,
                        "isSpecial": false,
                        "startTime": 1703694600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703771100,
                        "isSpecial": false,
                        "startTime": 1703761200
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703820600,
                        "isSpecial": false,
                        "startTime": 1703792700
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703860200,
                        "isSpecial": false,
                        "startTime": 1703847600
                    ],
                    [
                        "__typename": "OpenHours",
                        "courtType": "BADMINTON",
                        "endTime": 1703903400,
                        "isSpecial": false,
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
                "isSpecial": false,
                "startTime": 1703430000
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703563200,
                "isSpecial": false,
                "startTime": 1703502000
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703649600,
                "isSpecial": false,
                "startTime": 1703588400
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703736000,
                "isSpecial": false,
                "startTime": 1703674800
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703822400,
                "isSpecial": false,
                "startTime": 1703761200
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1703905200,
                "isSpecial": false,
                "startTime": 1703847600
            ]
        ],
        "imageUrl": "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg",
        "latitude": 42.453188923853595,
        "longitude": -76.47730907608567,
        "name": "Helen Newman"
    ]

    /// Dummy data for Teagle.
    let teagle: [String: Any] = [
        "__typename": "Gym",
        "id": "2",
        "address": "512 Campus Rd",
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
                    "updated": 1709155500
                ],
                "facilityType": "FITNESS",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709418600,
                        "isSpecial": false,
                        "startTime": 1709398800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709505000,
                        "isSpecial": false,
                        "startTime": 1709485200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709610300,
                        "isSpecial": false,
                        "startTime": 1709553600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709696700,
                        "isSpecial": false,
                        "startTime": 1709640000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709178300,
                        "isSpecial": false,
                        "startTime": 1709121600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709264700,
                        "isSpecial": false,
                        "startTime": 1709208000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709351100,
                        "isSpecial": false,
                        "startTime": 1709294400
                    ]
                ],
                "name": "Teagle Up Fitness Center"
            ],
            [
                "__typename": "Facility",
                "id": "2",
                "capacity": [
                    "__typename": "Capacity",
                    "count": 0,
                    "percent": 0.0,
                    "updated": 1709155320
                ],
                "facilityType": "FITNESS",
                "hours": [
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709418600,
                        "isSpecial": false,
                        "startTime": 1709398800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709505000,
                        "isSpecial": false,
                        "startTime": 1709485200
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709559000,
                        "isSpecial": false,
                        "startTime": 1709553600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709610300,
                        "isSpecial": false,
                        "startTime": 1709564400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709645400,
                        "isSpecial": false,
                        "startTime": 1709640000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709696700,
                        "isSpecial": false,
                        "startTime": 1709650800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709127000,
                        "isSpecial": false,
                        "startTime": 1709121600
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709178300,
                        "isSpecial": false,
                        "startTime": 1709132400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709213400,
                        "isSpecial": false,
                        "startTime": 1709208000
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709264700,
                        "isSpecial": false,
                        "startTime": 1709218800
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709299800,
                        "isSpecial": false,
                        "startTime": 1709294400
                    ],
                    [
                        "__typename": "OpenHours",
                        "endTime": 1709351100,
                        "isSpecial": false,
                        "startTime": 1709305200
                    ]
                ],
                "name": "Teagle Down Fitness Center"
            ]
        ],
        "hours": [
            [
                "__typename": "OpenHours",
                "endTime": 1709179200,
                "isSpecial": false,
                "startTime": 1709121600
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709265600,
                "isSpecial": false,
                "startTime": 1709208000
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709352000,
                "isSpecial": false,
                "startTime": 1709294400
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709420400,
                "isSpecial": false,
                "startTime": 1709391600
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709506800,
                "isSpecial": false,
                "startTime": 1709485200
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709611200,
                "isSpecial": false,
                "startTime": 1709553600
            ],
            [
                "__typename": "OpenHours",
                "endTime": 1709697600,
                "isSpecial": false,
                "startTime": 1709640000
            ]
        ],
        "imageUrl": "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/teagle.jpg",
        "latitude": 42.4459926380709,
        "longitude": -76.47915389837931,
        "name": "Teagle"
    ]

    /// Dummy data for open hours.
    let openHours: [[String: Any]] = [
        [
            "__typename": "OpenHours",
            "endTime": 1703509200, // Mon Dec 25 2023 13:00 UTC
            "isSpecial": false,
            "startTime": 1703502000 // Mon Dec 25 2023 11:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703595600, // Tue Dec 26 2023 13:00 UTC
            "isSpecial": false,
            "startTime": 1703588400 // Tue Dec 26 2023 11:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703610000, // Tue Dec 26 2023 17:00 UTC
            "isSpecial": false,
            "startTime": 1703602800 // Tue Dec 26 2023 15:00 UTC
        ],
        [
            "__typename": "OpenHours",
            "endTime": 1703617200, // Tue Dec 26 2023 19:00 UTC
            "isSpecial": false,
            "startTime": 1703613600 // Tue Dec 26 2023 18:00 UTC
        ]
    ]

    /// Dummy data for profile view.
    struct ProfileViewData {

        // Profile data
        static let profile = UserProfile(
            id: "user123",
            name: "Jiwon Jeong"
        )

        static let totalWorkouts = 132
        static let streaks = 14
        static let badges = 6

        // Create dates for the week
        static let weekDates: [Date] = {
            [25, 26, 27, 28, 29, 30, 31].map { day -> Date in
                var components = DateComponents()
                components.year = 2024
                components.month = 3
                components.day = day
                return Calendar.current.date(from: components) ?? Date()
            }
        }()

        static let weeklyWorkouts = WeeklyWorkoutData(
            currentWeekWorkouts: 0,
            weeklyGoal: 5,
            weekDates: weekDates
        )

        static let workoutHistory: [WorkoutHistory] = [
            WorkoutHistory(
                id: "workout1",
                location: "Helen Newman",
                time: "6:30 PM",
                date: "Fri Mar 29, 2024"
            ),
            WorkoutHistory(
                id: "workout2",
                location: "Teagle Up",
                time: "7:15 PM",
                date: "Thu Mar 28, 2024"
            ),
            WorkoutHistory(
                id: "workout3",
                location: "Helen Newman",
                time: "6:32 PM",
                date: "Tue Mar 26, 2024"
            ),
            WorkoutHistory(
                id: "workout4",
                location: "Toni Morrison",
                time: "7:37 PM",
                date: "Sun Mar 24, 2024"
            ),
            WorkoutHistory(
                id: "workout5",
                location: "Helen Newman",
                time: "10:02 AM",
                date: "Sat Mar 23, 2024"
            )
        ]
    }

    static let noyesCheckIn = Gym(
        id: "noyes",
        name: "Noyes",
        latitude: 42.44660528140398,
        longitude: -76.48803891048553,
        status: .open(closeTime: .distantFuture)
    )

    static let teagleCheckIn = Gym(
        id: "teagle",
        name: "Teagle",
        latitude: 42.4459926380709,
        longitude: -76.47915389837931,
        status: .open(closeTime: .distantFuture)
    )

    static let helenNewmanCheckIn = Gym(
        id: "helen",
        name: "Helen Newman",
        latitude: 42.453188923853595,
        longitude: -76.47730907608567,
        status: .open(closeTime: .distantFuture)
    )

    static let toniMorrison = Gym(
        id: "toni",
        name: "Toni Morrison",
        latitude: 42.45582093240726,
        longitude: -76.47883902202813,
        status: .open(closeTime: .distantFuture)
    )

    static let allGyms = [noyesCheckIn, teagleCheckIn, helenNewmanCheckIn, toniMorrison]
}
