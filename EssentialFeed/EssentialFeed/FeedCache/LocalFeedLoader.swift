//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by bekabeshka on 08.04.2023.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: (() -> Date)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}
    
extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
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

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(cachedFeed):
                switch cachedFeed {
                case let .some(cache) where FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                    completion(.success(cache.feed.toModels()))
                case .some, .none:
                    completion(.success([]))
                }
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: { _ in })
            case let .success(cacheFeed):
                switch cacheFeed {
                case let .some(cache) where !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                    self.store.deleteCachedFeed(completion: { _ in })
                case .none, .some: break
                }
            }
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
