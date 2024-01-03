//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by bekabeshka on 02.10.2023.
//  Copyright © 2023 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
