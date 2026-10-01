//
//  leonteq_taskTests.swift
//  leonteq taskTests
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation
import Testing
@testable import leonteq_task

@MainActor
struct RepositoryDecodingTests {
    @Test func decodesARepository() throws {
        let repository = try JSONDecoder().decode(Repository.self, from: Data(sampleJSON.utf8))

        #expect(repository.fullName == "swiftlang/swift")
        #expect(repository.summary == "The Swift Programming Language")
        #expect(repository.stargazersCount == 68000)
        #expect(repository.forksCount == 10500)
        #expect(repository.openIssuesCount == 6200)
        #expect(repository.owner.login == "swiftlang")
    }

    @Test func missingDescriptionBecomesNil() throws {
        let json = sampleJSON.replacingOccurrences(of: "\"The Swift Programming Language\"", with: "null")
        let repository = try JSONDecoder().decode(Repository.self, from: Data(json.utf8))
        #expect(repository.summary == nil)
    }
}

@MainActor
struct SearchViewModelTests {
    @Test func blankQueryStaysIdle() {
        let model = SearchViewModel(searchService: StubSearchService(), debounceInterval: .milliseconds(0))
        model.query = "   "
        model.queryDidChange()
        #expect(model.state == .idle)
    }

    @Test func searchNowShowsResults() async {
        let service = StubSearchService()
        service.items = [.preview]
        let model = SearchViewModel(searchService: service, debounceInterval: .milliseconds(0))
        model.query = "swift"

        await model.searchNow()

        #expect(model.state == .results([.preview]))
    }

    @Test func searchNowShowsEmptyState() async {
        let model = SearchViewModel(searchService: StubSearchService(), debounceInterval: .milliseconds(0))
        model.query = "nothing-matches-xyz"

        await model.searchNow()

        #expect(model.state == .empty)
    }

    @Test func failureShowsTheError() async {
        let service = StubSearchService()
        service.error = HTTPError.transport
        let model = SearchViewModel(searchService: service, debounceInterval: .milliseconds(0))
        model.query = "swift"

        await model.searchNow()

        #expect(model.state == .failed(HTTPError.transport.localizedDescription))
    }

    @Test func refreshKeepsTheListWhenTheRequestFails() async {
        let service = StubSearchService()
        service.items = [.preview]
        let model = SearchViewModel(searchService: service, debounceInterval: .milliseconds(0))
        model.query = "swift"
        await model.searchNow()

        service.error = HTTPError.statusCode(403)
        await model.refresh()

        #expect(model.state == .results([.preview]))
        #expect(model.refreshError == HTTPError.statusCode(403).localizedDescription)
    }
}

@Suite(.serialized)
@MainActor
struct GitHubRepositoryServiceTests {
    @Test func readsItemsFromASuccessfulResponse() async throws {
        let service = makeService(status: 200, body: """
        { "items": [\(sampleJSON)] }
        """)

        let items = try await service.searchRepositories(matching: "swift")

        #expect(items.count == 1)
        #expect(items[0].name == "swift")
    }

    @Test func failsOnForbiddenStatus() async throws {
        let service = makeService(status: 403, body: #"{"message":"rate limit"}"#)

        await #expect(throws: HTTPError.statusCode(403)) {
            try await service.searchRepositories(matching: "swift")
        }
    }

    @Test func failsOnInvalidJSON() async throws {
        let service = makeService(status: 200, body: "not-json")

        do {
            _ = try await service.searchRepositories(matching: "swift")
            Issue.record("Expected decoding to fail")
        } catch is DecodingError {
            // ok
        } catch {
            Issue.record("Expected DecodingError, got \(error)")
        }
    }
}

@MainActor
private final class StubSearchService: RepositorySearchService {
    var items: [Repository] = []
    var error: Error?

    func searchRepositories(matching query: String) async throws -> [Repository] {
        if let error {
            throw error
        }
        return items
    }
}

private final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var statusCode = 200
    nonisolated(unsafe) static var body = Data()

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url ?? URL(string: "https://api.github.com")!,
            statusCode: Self.statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

@MainActor
private func makeService(status: Int, body: String) -> GitHubRepositoryService {
    StubURLProtocol.statusCode = status
    StubURLProtocol.body = Data(body.utf8)

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [StubURLProtocol.self]
    let httpClient = URLSessionHTTPClient(session: URLSession(configuration: configuration))
    return GitHubRepositoryService(httpClient: httpClient)
}

private let sampleJSON = """
{
  "id": 44838949,
  "name": "swift",
  "full_name": "swiftlang/swift",
  "description": "The Swift Programming Language",
  "html_url": "https://github.com/swiftlang/swift",
  "stargazers_count": 68000,
  "forks_count": 10500,
  "open_issues_count": 6200,
  "language": "C++",
  "owner": {
    "login": "swiftlang",
    "avatar_url": "https://avatars.githubusercontent.com/u/10639145?v=4"
  }
}
"""
