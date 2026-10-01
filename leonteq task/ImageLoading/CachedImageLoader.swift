//
//  CachedImageLoader.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import UIKit

@MainActor
final class CachedImageLoader: ImageLoading {
    private let httpClient: HTTPClient
    private let cache = NSCache<NSURL, UIImage>()
    private var inFlight: [URL: Task<UIImage?, Never>] = [:]

    init(httpClient: HTTPClient, cacheLimit: Int = 100) {
        self.httpClient = httpClient
        cache.countLimit = cacheLimit
    }

    func cachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func image(for url: URL) async -> UIImage? {
        if let cached = cachedImage(for: url) {
            return cached
        }

        if let existing = inFlight[url] {
            return await existing.value
        }

        let task = Task<UIImage?, Never> {
            do {
                let data = try await httpClient.send(ImageRequest(url: url))
                guard let image = UIImage(data: data) else { return nil }
                cache.setObject(image, forKey: url as NSURL)
                return image
            } catch {
                return nil
            }
        }

        inFlight[url] = task
        let image = await task.value
        inFlight[url] = nil
        return image
    }
}
