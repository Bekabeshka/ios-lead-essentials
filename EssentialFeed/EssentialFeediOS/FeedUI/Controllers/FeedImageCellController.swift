//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 08.05.2023.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private lazy var cell = FeedImageCell()
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        
        if viewModel.isLoading {
            cell.feedImageContainer.startShimmering()
        } else {
            cell.feedImageContainer.stopShimmering()
        }
        
        cell.onRetry = delegate.didRequestImage
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
}
