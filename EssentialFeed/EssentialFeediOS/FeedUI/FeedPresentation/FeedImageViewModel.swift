//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import Foundation

struct FeedImageViewModel<T> {
    let description: String?
    let location: String?
    let image: T?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
