//
//  NullStore.swift
//  EssentialApp
//
//  Created by bekabeshka on 03.01.2024.
//

import Foundation
import EssentialFeedCache

class NullStore {}

extension NullStore: FeedStore {
    func deleteCachedFeed() throws { }
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws { }
    func retrieve() throws -> CachedFeed? { nil }
}

extension NullStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws { }
    func retrieve(dataForURL url: URL) throws -> Data? { nil }
}
