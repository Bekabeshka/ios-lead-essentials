//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by bekabeshka on 26.02.2023.
//

import Foundation

enum FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private static let OK_200 = 200

    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}