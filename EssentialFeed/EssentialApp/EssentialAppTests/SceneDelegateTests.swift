//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by bekabeshka on 08.10.2023.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

final class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
     
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        
        sut.window = UIWindow()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topControllre = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation)
        XCTAssertTrue(topControllre is FeedViewController)
    }
    
    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0
        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount = 1
        }
    }
}
