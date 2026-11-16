//
//  PersonalRecordsViewModel.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog

extension PersonalRecordsView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published private(set) var records: [PersonalRecord] = []
        @Published var celebratedRecord: PersonalRecord?

        private let defaults: UserDefaults
        private let now: () -> Date

        init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
            self.defaults = defaults
            self.now = now
            load()
        }

        // MARK: - Functions

        @discardableResult
        func log(lift: String, weight: Double, reps: Int) -> Bool {
            let name = lift.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty, weight > 0, reps > 0 else { return false }

            let entry = PersonalRecord.Entry(date: now(), reps: reps, weight: weight)
            var record = records.first { $0.lift.caseInsensitiveCompare(name) == .orderedSame }
                ?? PersonalRecord(lift: name)
            let isNewRecord = !record.beats(entry)

            record.entries.append(entry)
            records.removeAll { $0.id == record.id }
            records.insert(record, at: 0)
            save()

            if isNewRecord {
                celebratedRecord = record
            }
            return isNewRecord
        }

        func delete(_ record: PersonalRecord) {
            records.removeAll { $0.id == record.id }
            save()
        }

        func dateText(of entry: PersonalRecord.Entry) -> String {
            entry.date.formatted(date: .abbreviated, time: .omitted)
        }

        func bestText(of record: PersonalRecord) -> String {
            guard let best = record.best else { return "No sets yet" }
            return "\(best.weight.formatted()) lb / \(best.reps) rep\(best.reps == 1 ? "" : "s")"
        }

        func progressText(of record: PersonalRecord) -> String {
            guard let first = record.history.first, let best = record.best, record.entries.count > 1 else {
                return "Log more sets to see your progress"
            }

            let gain = best.weight - first.weight
            let since = first.date.formatted(.dateTime.month(.abbreviated).day())
            return gain > 0 ? "+\(gain.formatted()) lb since \(since)" : "Holding strong since \(since)"
        }

        private func load() {
            guard let data = defaults.data(forKey: Constants.UserDefaultsKeys.personalRecords) else { return }

            do {
                records = try JSONDecoder().decode([PersonalRecord].self, from: data)
            } catch {
                Logger.data.error("Error in PersonalRecordsViewModel.load: \(error)")
            }
        }

        private func save() {
            do {
                defaults.set(try JSONEncoder().encode(records), forKey: Constants.UserDefaultsKeys.personalRecords)
            } catch {
                Logger.data.error("Error in PersonalRecordsViewModel.save: \(error)")
            }
        }

    }

}
