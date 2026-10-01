//
//  SearchViewModel.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    var query = ""
    private(set) var state: SearchViewState = .idle
    private(set) var refreshError: String?
    private(set) var isSearching = false

    private let searchService: RepositorySearchService
    private let debounceInterval: Duration
    private var searchTask: Task<Void, Never>?
    private var requestID = 0

    init(
        searchService: RepositorySearchService,
        debounceInterval: Duration = .milliseconds(400)
    ) {
        self.searchService = searchService
        self.debounceInterval = debounceInterval
    }

    func queryDidChange() {
        refreshError = nil
        searchTask?.cancel()

        let text = normalizedQuery
        guard !text.isEmpty else {
            requestID += 1
            isSearching = false
            state = .idle
            return
        }

        let currentRequestID = nextRequestID()
        searchTask = Task { [debounceInterval] in
            try? await Task.sleep(for: debounceInterval)
            guard !Task.isCancelled else { return }

            if showsExistingResults {
                isSearching = true
            } else {
                state = .loading
            }

            await performSearch(text, requestID: currentRequestID, isRefresh: false)
        }
    }

    func searchNow() async {
        searchTask?.cancel()
        refreshError = nil
        isSearching = false

        let text = normalizedQuery
        guard !text.isEmpty else {
            state = .idle
            return
        }

        state = .loading
        await performSearch(text, requestID: nextRequestID(), isRefresh: false)
    }

    func refresh() async {
        searchTask?.cancel()

        let text = normalizedQuery
        guard !text.isEmpty else { return }

        refreshError = nil
        await performSearch(text, requestID: nextRequestID(), isRefresh: true)
    }

    private var normalizedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var showsExistingResults: Bool {
        if case .results = state { return true }
        return false
    }

    private func nextRequestID() -> Int {
        requestID += 1
        return requestID
    }

    private func performSearch(_ text: String, requestID: Int, isRefresh: Bool) async {
        do {
            let repositories = try await searchService.searchRepositories(matching: text)
            guard requestID == self.requestID else { return }

            isSearching = false
            refreshError = nil
            state = repositories.isEmpty ? .empty : .results(repositories)
        } catch {
            guard requestID == self.requestID else { return }
            guard !error.isCancellation else { return }

            isSearching = false
            let message = UserFacingError.message(for: error)
            if isRefresh, case .results = state {
                refreshError = message
            } else {
                state = .failed(message)
            }
        }
    }
}

private extension Error {
    var isCancellation: Bool {
        if self is CancellationError { return true }
        if let urlError = self as? URLError, urlError.code == .cancelled { return true }
        return false
    }
}
