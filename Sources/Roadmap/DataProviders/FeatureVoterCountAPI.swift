//
//  FeatureVoterCountAPI.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

public struct FeatureVoterCountAPI: FeatureVoter {
    let baseUrl: URL
    
    /// - Parameter baseUrl: API address
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    /// Fetches the current count for the given feature.
    /// - Returns: The current `count`, else `0` if unsuccessful.
    public func fetch(for feature: RoadmapFeature) async -> Int {
        guard feature.hasNotFinished else {
            return 0
        }
        do {
            let requestUrl = baseUrl.appendingPathComponent("\(feature.id)")
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.get(url: requestUrl)
            return count.value ?? 0
        } catch {
            print(error)
            print("Fetching voting count failed with error: \(error.localizedDescription)")
            return 0
        }
    }

    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    public func vote(for feature: RoadmapFeature) async -> Int? {
        guard feature.hasNotFinished else {
            return nil
        }
        
        do {
            let requestUrl = baseUrl.appendingPathComponent("\(feature.id)")
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.patch(url: requestUrl)
            feature.hasVoted = true
            print("Successfully voted, count is now: \(count)")
            return count.value
        } catch {
            print("Voting failed: \(error.localizedDescription)")
            return nil
        }
    }
}
