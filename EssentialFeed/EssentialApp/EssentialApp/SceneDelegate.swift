//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by bekabeshka on 12.08.2023.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStoreUrl = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")
        let localStore = try! CoreDataFeedStore(storeURL: localStoreUrl)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(primary: remoteFeedLoader, fallback: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: remoteImageLoader)
        )
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = feedViewController
        window?.makeKeyAndVisible()
    }
}
