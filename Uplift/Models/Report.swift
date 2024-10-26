//
//  Report.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/25/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import UpliftAPI

/// Model representing a report.
struct Report: Hashable {

    // MARK: - Properties

    /// The time at which this report was created.
    let createdAt: DateTime

    /// The desscription of this report.
    let description: String

    /// The gym this report is associated with.
    let gym: Gym?

    /// The ID of the gym in which this report is associated with.
    let gymId: Int

    /// The issue for this report.
    let issue: ReportType

    /// The user this report is associated with.
    let user: User?

    /// The ID of the user in which this report is associated with.
    let userId: Int

    // MARK: - Functions

    /// Initializes this object given a `ReportFields` type.
//    init(from report: ReportFields) {
//        // Unwrap and convert GraphQL enum value to Swift enum value
//        self.accessibility = equipment.accessibility?.value
//        self.equipmentType = equipment.equipmentType.value
//        self.facilityId = equipment.facilityId
//        self.name = equipment.name
//        self.quantity = equipment.quantity
//    }

}
