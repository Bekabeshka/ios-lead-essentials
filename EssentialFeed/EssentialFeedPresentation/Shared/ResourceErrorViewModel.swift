//
//  ResourceErrorViewModel.swift
//  EssentialFeedPresentation
//
//  Created by bekabeshka on 02.01.2024.
//  Copyright © 2024 Essential Developer. All rights reserved.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
