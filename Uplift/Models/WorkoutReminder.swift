//
//  WorkoutReminder.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/21/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//
import Foundation

struct WorkoutReminder: Identifiable, Hashable, Codable {
    let id: UUID
    let selectedDays: [DayOfWeek]
    let isAllDay: Bool
    let time: String
    var isEnabled: Bool = true

    var daysText: String {
        if selectedDays.count == 7 {
            return "Every Day"
        } else if selectedDays.count == 1 {
            return selectedDays.first?.dayOfWeekComplete() ?? ""
        } else if selectedDays.count == 2 &&
                    selectedDays.contains(.saturday) &&
                    selectedDays.contains(.sunday) {
            return "Weekends"
        } else if selectedDays.count == 5 &&
                    !selectedDays.contains(.saturday) &&
                    !selectedDays.contains(.sunday) {
            return "Weekdays"
        }

        return selectedDays
            .map { $0.dayOfWeekAbbreviation() }
            .sorted()
            .joined(separator: " ")
    }

    enum CodingKeys: String, CodingKey {
        case id, selectedDays, isAllDay, time, isEnabled
    }

    init(
        id: UUID = UUID(),
        selectedDays: [DayOfWeek],
        isAllDay: Bool,
        time: String,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.selectedDays = selectedDays
        self.isAllDay = isAllDay
        self.time = time
        self.isEnabled = isEnabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        selectedDays = try container.decode([DayOfWeek].self, forKey: .selectedDays)
        isAllDay = try container.decode(Bool.self, forKey: .isAllDay)
        time = try container.decode(String.self, forKey: .time)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
    }
}
