//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 20.02.2023.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotReqeustDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_reqeustsDataFromURL() {
        let url = URL(string: "http://yatorogod.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load() { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_reqeustsDataFromURLTwice() {
        let url = URL(string: "http://yatorogod.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load() { _ in }
        sut.load() { _ in }
        XCTAssertEqual(2, client.requestedURLs.count)
        XCTAssertEqual([url, url], client.requestedURLs)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let error = NSError(domain: "", code: 0)
            client.complete(with: error)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_delivaersErrorOn200HTPPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: Data())
        }
    }
    
    func test_load_delivaersErrorOn200HTPPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJson = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJson)
        }
    }
    
    func test_load_delivaersErrorOn200HTPPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(), description: nil, location: nil, imageURL: URL(string: "http://yatorogod.com")!)
        let item2 = makeItem(id: UUID(), description: "description", location: "location", imageURL: URL(string: "http://yatorogod.com")!)
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWithResult: .success(items)) {
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    private func makeSUT(url: URL = URL(string: "http://yatorogod.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let remoteLoader = RemoteFeedLoader(url: url, client: httpClient)
        return (remoteLoader, httpClient)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let itemsJSON = ["items": items]
        let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
        return json
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].reduce(into: [String: Any]()) { acc, e in
            if let value = e.value {
                acc[e.key] = value
            }
        }

        return (item, json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturesResults: [RemoteFeedLoader.Result] = []
        sut.load { capturesResults.append($0) }
        action()
        XCTAssertEqual(capturesResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private var messages: [(url: URL, completion: ((HTTPClientResult) -> Void))] = []
        
        func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}
