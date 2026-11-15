//
//  PersonalRecordTests.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

struct PersonalRecordTests {

    private func entry(_ weight: Double, _ reps: Int, day: Double = 0) -> PersonalRecord.Entry {
        PersonalRecord.Entry(date: Date(timeIntervalSince1970: day * 86_400), reps: reps, weight: weight)
    }

    @Test func picksHeaviestThenMostReps() {
        let record = PersonalRecord(lift: "Bench Press", entries: [entry(225, 1), entry(225, 3), entry(185, 10)])

        #expect(record.best == entry(225, 3))
    }

    @Test func levelsUpAtPlateMilestones() {
        #expect(PersonalRecord.Tier(weight: 95) == .starter)
        #expect(PersonalRecord.Tier(weight: 135) == .onePlate)
        #expect(PersonalRecord.Tier(weight: 250) == .twoPlates)
        #expect(PersonalRecord.Tier(weight: 315) == .threePlates)
    }

    @Test func detectsWhenEntryIsNotANewRecord() {
        let record = PersonalRecord(lift: "Squat", entries: [entry(275, 5)])

        #expect(record.beats(entry(275, 4)))
        #expect(record.beats(entry(275, 5)))
        #expect(!record.beats(entry(275, 6)))
        #expect(!PersonalRecord(lift: "Squat").beats(entry(45, 1)))
    }

    @Test func sortsHistoryByDate() {
        let record = PersonalRecord(lift: "Deadlift", entries: [entry(315, 1, day: 2), entry(275, 1, day: 1)])

        #expect(record.history.map(\.weight) == [275, 315])
    }

    @MainActor @Test func logsNewRecordsAndPersistsThem() throws {
        let defaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        let viewModel = PersonalRecordsView.ViewModel(defaults: defaults)

        #expect(viewModel.log(lift: "Bench Press", weight: 185, reps: 5))
        #expect(!viewModel.log(lift: "bench press ", weight: 165, reps: 5))
        #expect(viewModel.log(lift: "Bench Press", weight: 205, reps: 1))
        #expect(!viewModel.log(lift: "Squat", weight: 0, reps: 5))

        let reloaded = PersonalRecordsView.ViewModel(defaults: defaults)
        #expect(reloaded.records.count == 1)
        #expect(reloaded.records.first?.entries.count == 3)
        #expect(reloaded.records.first?.best?.weight == 205)
    }

}
