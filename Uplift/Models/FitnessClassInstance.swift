//
//  FitnessClassInstance.swift
//  Uplift
//
//  Created by Caitlyn Jin on 4/20/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a class instance (session).
struct FitnessClassInstance: Hashable {

    // MARK: - Properties

    /// The ID of this class instance.
    let id: String

    /// The class ID of this class instance.
    let classId: Int

    /// The class of this class instance.
    let fitnessClass: FitnessClass?

    /// The end time of this class instance.
    let endTime: String?

    /// The instructor of this class instance.
    let instructor: String

    /// Whether this class instance is canceled.
    let isCanceled: Bool

    /// Whether this class instance is virtual.
    let isVirtual: Bool

    /// The location of this class instance.
    let location: String

    /// The start time of this class instance.
    let startTime: String?

}
