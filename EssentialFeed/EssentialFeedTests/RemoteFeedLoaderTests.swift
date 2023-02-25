//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 20.02.2023.
//

import XCTest
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    var requestedURLs: [URL] = []
    func get(from url: URL) {
        requestedURLs.append(url)
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotReqeustDataFromURL() {
        let url = URL(string: "http://yatorogod.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_reqeustsDataFromURL() {
        let url = URL(string: "http://yatorogod.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_reqeustsDataFromURLTwice() {
        let url = URL(string: "http://yatorogod.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        sut.load()
        XCTAssertEqual(2, client.requestedURLs.count)
        XCTAssertEqual(url, client.requestedURLs.first)
    }
    
    private func makeSUT(url: URL) -> (RemoteFeedLoader, HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let remoteLoader = RemoteFeedLoader(url: url, client: httpClient)
        return (remoteLoader, httpClient)
    }
}
