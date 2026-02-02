//
//  ClassesCache.swift
//  Uplift
//
//  Created by Jiwon Jeong on 11/13/25.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import UpliftAPI
import Combine

/// Actor-based cache for fitness class instances that prevents duplicate network requests
actor ClassesCache {

    // MARK: Properties

    static let shared = ClassesCache()

    private var cachedEntry: CacheEntry?
    private let cacheTimeout: TimeInterval = 300

    enum CacheEntry {
        case inProgress(Task<[FitnessClassInstance], Error>)
        case ready([FitnessClassInstance], fetchedAt: Date)
    }

    // MARK: Functions

    /// Fetches all fitness classes from the network with intelligent caching
    func fetchClasses() async throws -> [FitnessClassInstance] {
        if let entry = cachedEntry {
            switch entry {
            case .ready(let classes, let fetchedAt):
                if Date().timeIntervalSince(fetchedAt) < cacheTimeout {
                    return classes
                }

            case .inProgress(let task):
                return try await task.value
            }
        }

        let task = Task<[FitnessClassInstance], Error> {
            try await performFetch()
        }

        cachedEntry = .inProgress(task)

        do {
            let classes = try await task.value
            cachedEntry = .ready(classes, fetchedAt: Date())
            return classes
        } catch {
            cachedEntry = nil
            throw error
        }
    }

    /// Clears the cached class data
    func invalidateCache() {
        cachedEntry = nil
    }

    /// Performs the actual network request to fetch classes from the backend API
    private func performFetch() async throws -> [FitnessClassInstance] {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?

            cancellable = Network.client.queryPublisher(
                query: GetAllGymsQuery(),
                cachePolicy: .fetchIgnoringCacheCompletely
            )
            .compactMap { $0.data?.gyms?.compactMap(\.?.fragments.gymFields) }
            .sink { completion in
                if case let .failure(error) = completion {
                    continuation.resume(throwing: error)
                }
                cancellable?.cancel()
            } receiveValue: { gymFields in
                let gyms: [Gym] = gymFields.map { Gym(from: $0) }
                let classes = gyms.flatMap { $0.classes }
                continuation.resume(returning: classes)
                cancellable?.cancel()
            }
        }
    }

}
