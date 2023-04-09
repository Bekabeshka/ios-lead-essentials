//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 09.04.2023.
//

import Foundation
import EssentialFeed

final class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    private var deletionCompleitons: [DeletionCompletion] = []
    private var insertionCompleitons: [InsertionCompletion] = []
    private var retrievalCompletions: [RetrievalCompletion] = []
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompleitons.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompleitons[index](error)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompleitons[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompleitons[index](nil)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompleitons[index](nil)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.found(feed: feed, timestamp: timestamp))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(feed, timestamp))
        insertionCompleitons.append(completion)
    }
}
