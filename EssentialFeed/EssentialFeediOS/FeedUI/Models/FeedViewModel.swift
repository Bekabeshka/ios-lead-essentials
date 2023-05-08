//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import EssentialFeed

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onFeedLoad: Observer<[FeedImage]>?
    var onLoadingStateChange: Observer<Bool>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onFeedLoad?(feed)
            case .failure: break
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
