//
//  GitHubRepositoryService.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct GitHubRepositoryService: RepositorySearchService {
    private let httpClient: HTTPClient
    private let decoder: JSONDecoder

    init(httpClient: HTTPClient, decoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = httpClient
        self.decoder = decoder
    }

    func searchRepositories(matching query: String) async throws -> [Repository] {
        let data = try await httpClient.send(GitHubSearchRequest(query: query))
        return try decoder.decode(SearchRepositoriesResponse.self, from: data).items
    }
}
