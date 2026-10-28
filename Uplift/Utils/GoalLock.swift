//
//  GoalLock.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/28/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import UpliftAPI

enum GoalLock {

    static let lockDays = 30

    static func isLocked(lastGoalChange: DateTime?, now: Date = .now) -> Bool {
        guard let unlockDate = unlockDate(lastGoalChange: lastGoalChange) else { return false }
        return unlockDate > now
    }

    static func unlockDate(lastGoalChange: DateTime?) -> Date? {
        guard let lastGoalChange else { return nil }

        guard let lastChangeDate = formatter.date(from: lastGoalChange) else {
            Logger.data.error("Could not parse lastGoalChange: \(lastGoalChange)")
            return nil
        }

        return Calendar.current.date(byAdding: .day, value: lockDays, to: lastChangeDate)
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()

}
