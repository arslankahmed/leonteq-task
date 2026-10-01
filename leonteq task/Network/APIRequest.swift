//
//  APIRequest.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

protocol APIRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIRequest {
    var path: String { "" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }

    func makeURLRequest() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw HTTPError.invalidURL
        }

        let extra = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if !extra.isEmpty {
            let current = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            components.path = "/" + [current, extra].filter { !$0.isEmpty }.joined(separator: "/")
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw HTTPError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = cachePolicy
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        return request
    }
}
