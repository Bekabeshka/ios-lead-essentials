//
//  SharedLocalizationTests.swift
//  EssentialFeedPresentationTests
//
//  Created by bekabeshka on 02.01.2024.
//  Copyright © 2024 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeedPresentation

class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

}
