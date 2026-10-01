//
//  AppDependencies.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct AppDependencies {
    let httpClient: HTTPClient
    let searchService: RepositorySearchService
    let imageLoader: ImageLoading
    let searchViewModel: SearchViewModel

    @MainActor
    static func live() -> AppDependencies {
        let httpClient = URLSessionHTTPClient()
        let searchService = GitHubRepositoryService(httpClient: httpClient)
        let imageLoader = CachedImageLoader(httpClient: httpClient)

        return AppDependencies(
            httpClient: httpClient,
            searchService: searchService,
            imageLoader: imageLoader,
            searchViewModel: SearchViewModel(searchService: searchService)
        )
    }

    @MainActor
    static func preview() -> AppDependencies {
        live()
    }
}
