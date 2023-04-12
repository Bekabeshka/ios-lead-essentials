//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by bekabeshka on 08.04.2023.
//

import Foundation

public class LocalFeedLoader {
    private let calendar = Calendar(identifier: .gregorian)
    
    let store: FeedStore
    let currentDate: (() -> Date)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCachedAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return currentDate() < maxCachedAge
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
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
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
            case let .found(_, timestamp) where !self.validate(timestamp):
                self.store.deleteCachedFeed(completion: { _ in })
            case .empty, .found: break
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