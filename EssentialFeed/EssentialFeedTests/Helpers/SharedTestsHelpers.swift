//
//  SharedTestsHelpers.swift
//  EssentialFeedTests
//
//  Created by bekabeshka on 12.04.2023.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
