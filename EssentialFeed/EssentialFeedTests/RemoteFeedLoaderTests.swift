//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 20.02.2023.
//

import XCTest

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.requestedURL = url
    }
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotReqeustDataFromURL() {
        let url = URL(string: "http://yatorogod.com")!
        let client = HTTPClient()
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_reqeustDataFromURL() {
        let url = URL(string: "http://yatorogod.com")!
        let client = HTTPClient()
        let sut = RemoteFeedLoader(url: url, client: client)
        sut.load()
        XCTAssertEqual(url, client.requestedURL)
    }
}
