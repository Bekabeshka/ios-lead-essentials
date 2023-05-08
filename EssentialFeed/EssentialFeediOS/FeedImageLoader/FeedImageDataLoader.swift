//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import Foundation

public protocol FeedImageDataLoaderDataTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping ((Result) -> Void)) -> FeedImageDataLoaderDataTask
}
