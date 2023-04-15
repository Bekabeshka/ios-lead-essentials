//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by bekabeshka on 15.04.2023.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    private let storeURL: URL
    private let bundle: Bundle
    
    public init(storeURL: URL, bundle: Bundle) {
        self.storeURL = storeURL
        self.bundle = bundle
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
}
