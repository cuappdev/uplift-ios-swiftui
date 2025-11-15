//
//  GymCache.swift
//  Uplift
//
//  Created by Jiwon Jeong on 11/13/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import UpliftAPI
import Combine

/// Actor-based cache for gyms that prevents duplicate network requests
actor GymCache {

    // MARK: Properties

    static let shared = GymCache()

    private var cachedEntry: CacheEntry?
    private let cacheTimeout: TimeInterval = 300 // 5 minutes (feel free to change future developer!)

    enum CacheEntry {
        case inProgress(Task<[Gym], Error>)
        case ready([Gym], fetchedAt: Date)
    }

    // MARK: Functions

    /// Fetches all gyms from the network with intelligent caching to prevent duplicate requests.
    func fetchGyms() async throws -> [Gym] {
        // Check if we have valid cached data
        if let entry = cachedEntry {
            switch entry {
            case .ready(let gyms, let fetchedAt):
                if Date().timeIntervalSince(fetchedAt) < cacheTimeout {
                    return gyms
                }
            case .inProgress(let task):
                return try await task.value
            }
        }

        // Create a new fetch task
        let task = Task<[Gym], Error> {
            try await performFetch()
        }

        // Now we mark it in progress
        cachedEntry = .inProgress(task)

        do {
            let gyms = try await task.value
            // If done, mark it ready with the result with timestamp
            cachedEntry = .ready(gyms, fetchedAt: Date())
            return gyms
        } catch {
            cachedEntry = nil
            throw error
        }
    }

    /// Clears the cached gym data
    func invalidateCache() {
        cachedEntry = nil
    }

    /// Performs the actual network request to fetch gyms from the backend API
    private func performFetch() async throws -> [Gym] {
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
                let gyms = [Gym](gymFields)
                continuation.resume(returning: gyms)
                cancellable?.cancel()
            }
        }
    }

}
