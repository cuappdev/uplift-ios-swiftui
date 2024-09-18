//
//  Gym.swift
//  Uplift
//
//  Created by Vin Bui on 12/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a gym.
struct Gym: Hashable {

    // MARK: - Properties

    /// The ID of this gym (building).
    let id: String

    /// The address of the building.
    let address: String

    /// This gym's amenities.
    let amenities: [AmenityType]

    /// This gym's classes.
    var classes: [FitnessClassInstance]

    /// This gym's facilities.
    let facilities: [Facility]

    /// This gym's fitness centers.
    var fitnessCenters: [Facility] {
        facilities.filter { $0.facilityType == .fitness }
    }

    /// This gym's building hours.
    let hours: [OpenHours]

    /// The URL of the image of this gym.
    let imageUrl: URL?

    /// The latitude coordinate of this gym.
    let latitude: Double

    /// The longitude coordinate of this gym.
    let longitude: Double

    /// The name of this gym.
    let name: String

    /// The status of this gym.
    let status: Status?

    // MARK: - Functions

    /// Initializes this object given a `GymFields` type.
    init(from gym: GymFields) {
        self.id = gym.id
        self.address = gym.address
        self.amenities = gym.amenities?.compactMap(\.?.type.value) ?? []

        self.classes = [FitnessClassInstance](gym.classes?.compactMap {
            if let id = $0?.id,
               let classId = $0?.classId,
               let fitnessClass = $0?.class_,
               let endTime = $0?.endTime,
               let instructor = $0?.instructor,
               let isCanceled = $0?.isCanceled,
               let isVirtual = $0?.isVirtual,
               let location = $0?.location,
               let startTime = $0?.startTime {
                return FitnessClassInstance(
                    id: id,
                    classId: classId,
                    fitnessClass: FitnessClass(id: fitnessClass.id, description: fitnessClass.description, name: fitnessClass.name),
                    endTime: endTime,
                    instructor: instructor,
                    isCanceled: isCanceled,
                    isVirtual: isVirtual,
                    location: location,
                    startTime: startTime
                )
            } else {
                return nil
            }
        } ?? [])

        self.facilities = [Facility](gym.facilities?.compactMap(\.?.fragments.facilityFields) ?? [])
        self.hours = [OpenHours](gym.hours?.compactMap(\.?.fragments.openHoursFields) ?? [])
        self.imageUrl = {
            guard let stringUrl = gym.imageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.name = gym.name
        self.status = self.hours.getStatus()
    }

    /// Returns the highest capacity fitness center for this gym (Teagle).
    func highestCapacityFC() -> Facility? {
        let defaultPercent = Double.leastNormalMagnitude
        return fitnessCenters.max {
            $0.capacity?.percent ?? defaultPercent > $1.capacity?.percent ?? defaultPercent
        }
    }

    /**
     Returns the facility given a name.

     Facility names are unique.
     */
    func facilityWithName(name: String) -> Facility? {
        facilities.first { $0.name == name }
    }

    /// Returns all facilities that are not fitness centers.
    func nonFCFacilities() -> [Facility] {
        facilities.filter { $0.facilityType != .fitness }
    }

    /**
     Determine whether at least one fitness center is open at this `Gym` depending on its fitness centers' hours.

     - Parameters:
        - currentTime: The current time to compare with and determine the status. Default is now.

     - Returns: A `Bool` representing whether at least one of its fitness centers is open.
     */
    func fitnessCenterIsOpen(currentTime: Date = Date.now) -> Bool {
        fitnessCenters.contains {
            switch $0.hours.getStatus(currentTime: currentTime) {
            case .open:
                return true
            default:
                return false
            }
        }
    }

    /**
     Retrieve the status of the `Gym` depending on the fitness centers' hours.

     - Parameters:
        - currentTime: The current time to compare with and determine the status. Default is now.

     - Returns: A `Status` object based on its fitness centers' hours. `nil` if there are no hours in the future.
     */
    func determineStatus(currentTime: Date = Date.now) -> Status? {
        if fitnessCenterIsOpen(currentTime: currentTime) {
            // Get all possible close times
            let closeTimes = fitnessCenters.compactMap {
                switch $0.hours.getStatus(currentTime: currentTime) {
                case .open(let closeTime):
                    return closeTime
                default:
                    return nil
                }
            }

            // Get the latest closing time
            if let closeTime = closeTimes.max() {
                return Status.open(closeTime: closeTime)
            }
        } else {
            // Get all possible open times
            let openTimes = fitnessCenters.compactMap {
                switch $0.hours.getStatus(currentTime: currentTime) {
                case .closed(let openTime):
                    return openTime
                default:
                    return nil
                }
            }

            // Get the earliest open time
            if let openTime = openTimes.min() {
                return Status.closed(openTime: openTime)
            }
        }
        return nil
    }

}
