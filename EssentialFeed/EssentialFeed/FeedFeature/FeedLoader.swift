//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by bekabeshka on 20.02.2023.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
