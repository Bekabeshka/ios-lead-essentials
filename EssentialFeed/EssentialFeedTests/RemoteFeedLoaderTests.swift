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
    var error: Error?
    
    func get(from url: URL, completion: @escaping ((Error) -> Void)) {
        if let error = error {
            completion(error)
        }
        requestedURLs.append(url)
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotReqeustDataFromURL() {
        let (_, client) = makeSUT()
        
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
        XCTAssertEqual([url, url], client.requestedURLs)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "", code: 0)
        
        var capturesErrors: [RemoteFeedLoader.Error] = []
        sut.load { capturesErrors.append($0) }
        
        XCTAssertEqual(capturesErrors, [.connectivity])
    }
    
    private func makeSUT(url: URL = URL(string: "http://yatorogod.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let remoteLoader = RemoteFeedLoader(url: url, client: httpClient)
        return (remoteLoader, httpClient)
    }
}
