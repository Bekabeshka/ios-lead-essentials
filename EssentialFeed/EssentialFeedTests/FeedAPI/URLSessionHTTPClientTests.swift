//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 26.02.2023.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnReqeustError() {
        let url = URL(string: "https://any-url.com")!
        let error = NSError(domain: "test", code: 1)
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class URLSessionSpy: URLSession {
        private struct Stub {
            let dataTask: URLSessionDataTask
            let error: Error?
        }
        
        private var stubs: [URL: Stub] = [:]
        
        func stub(url: URL, task: URLSessionDataTask, error: Error? = nil) {
            stubs[url] = Stub(dataTask: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.dataTask
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() { }
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
