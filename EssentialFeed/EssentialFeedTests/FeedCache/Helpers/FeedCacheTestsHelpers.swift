//
//  FeedCacheTestsHelpers.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 12.04.2023.
//

import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let localFeed = feed.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (feed, localFeed)
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .second, value: seconds, to: self)!
    }
}
