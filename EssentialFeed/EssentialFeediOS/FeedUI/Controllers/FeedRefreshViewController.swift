//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onRefresh?(feed)
            case .failure: break
            }
            self?.view.endRefreshing()
        }
    }
}
