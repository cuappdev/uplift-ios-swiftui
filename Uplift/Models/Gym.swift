//
//  Gym.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import Foundation
import UpliftAPI

/// Model representing a Gym.
struct Gym: Hashable {

    // MARK: - Properties

    /// This gym's unique identifier.
    let id: String

    /// This gym's description.
    let description: String

    /// The URL of the image of this gym.
    let imageUrl: URL?

    /// The location where this gym is located.
    let location: String

    /// The latitude coordinate of this gym.
    let latitude: Double

    /// The longitude coordinate of this gym.
    let longitude: Double

    /// The name of this gym.
    let name: String

    // MARK: - Initializer

    init(from gym: GymFields) {
        self.id = gym.id
        self.description = gym.description
        self.imageUrl = {
            guard let stringUrl = gym.imageUrl else { return nil }
            return URL(string: stringUrl)
        }()
        self.location = gym.location
        self.latitude = gym.latitude
        self.longitude = gym.longitude
        self.name = gym.name
    }

}

extension Array where Element == Gym {

    /// Map an array of `GymFields` to an array of `Gym` objects.
    init(_ gyms: [GymFields]) {
        self.init(gyms.map(Gym.init))
    }

}
