//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by bekabeshka on 08.04.2023.
//

import Foundation

public class LocalFeedLoader {
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    private let calendar = Calendar(identifier: .gregorian)
    
    let store: FeedStore
    let currentDate: (() -> Date)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))
            case .empty, .found:
                completion(.success([]))
            }
        }
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCachedAge = calendar.date(byAdding: .day, value: 7, to: timestamp) else { return false }
        return currentDate() < maxCachedAge
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping ((LocalFeedLoader.SaveResult) -> Void)) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            if let error = error {
                completion(error)
            } else {
                self.cache(feed, with: completion)
                
            }
        }
    }
    
    private func cache(_ items: [FeedImage], with completion: @escaping (LocalFeedLoader.SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
