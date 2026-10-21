//
//  WorkoutReminder.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/21/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

struct WorkoutReminder: Hashable, Codable {
    let selectedDays: [DayOfWeek]
    let isAllDay: Bool
    let time: String
    var isEnabled: Bool = true

    enum CodingKeys: String, CodingKey {
        case selectedDays, isAllDay, time, isEnabled
    }

    init(
        selectedDays: [DayOfWeek],
        isAllDay: Bool,
        time: String,
        isEnabled: Bool = true
    ) {
        self.selectedDays = selectedDays
        self.isAllDay = isAllDay
        self.time = time
        self.isEnabled = isEnabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedDays = try container.decode([DayOfWeek].self, forKey: .selectedDays)
        isAllDay = try container.decode(Bool.self, forKey: .isAllDay)
        time = try container.decode(String.self, forKey: .time)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
    }
}
