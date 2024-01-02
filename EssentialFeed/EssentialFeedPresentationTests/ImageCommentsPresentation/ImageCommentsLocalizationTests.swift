//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedPresentation
//
//  Created by bekabeshka on 02.01.2024.
//  Copyright © 2024 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

}
