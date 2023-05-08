//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() { }
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedViewController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedViewController, loader: imageLoader)
        return feedViewController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> (([FeedImage]) -> Void) {
        return { [weak controller] feed in
            controller?.tableModel = feed.map {
                let viewModel = FeedImageViewModel(model: $0, imageLoader: loader, imageTransformer: UIImage.init)
                return FeedImageCellController(viewModel: viewModel)
            }
        }
    }
}
