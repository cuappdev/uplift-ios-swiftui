//
//  PersonalRecord.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct PersonalRecord: Codable, Hashable, Identifiable {

    // MARK: - Types

    struct Entry: Codable, Hashable {
        let date: Date
        let reps: Int
        let weight: Double
    }

    enum Tier: Int, Comparable {
        case starter
        case onePlate
        case twoPlates
        case threePlates

        init(weight: Double) {
            switch weight {
            case Constants.PersonalRecords.threePlates...:
                self = .threePlates
            case Constants.PersonalRecords.twoPlates...:
                self = .twoPlates
            case Constants.PersonalRecords.onePlate...:
                self = .onePlate
            default:
                self = .starter
            }
        }

        static func < (lhs: Tier, rhs: Tier) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    // MARK: - Properties

    var entries: [Entry]
    let id: UUID
    let lift: String

    // MARK: - Init

    init(lift: String, entries: [Entry] = [], id: UUID = UUID()) {
        self.entries = entries
        self.id = id
        self.lift = lift
    }

    // MARK: - Computed Properties

    var best: Entry? {
        entries.max { ($0.weight, $0.reps) < ($1.weight, $1.reps) }
    }

    var tier: Tier {
        Tier(weight: best?.weight ?? 0)
    }

    var history: [Entry] {
        entries.sorted { $0.date < $1.date }
    }

    // MARK: - Functions

    func beats(_ entry: Entry) -> Bool {
        guard let best else { return false }
        return (best.weight, best.reps) >= (entry.weight, entry.reps)
    }

}
