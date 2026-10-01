//
//  GitHubSearchRequest.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct GitHubSearchRequest: APIRequest {
    let query: String

    var baseURL: URL { URL(string: "https://api.github.com")! }
    var path: String { "search/repositories" }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "per_page", value: "30")
        ]
    }

    var headers: [String: String] {
        [
            "User-Agent": "LeonteqTask/1.0",
            "Accept": "application/vnd.github+json"
        ]
    }

    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalCacheData }
}
