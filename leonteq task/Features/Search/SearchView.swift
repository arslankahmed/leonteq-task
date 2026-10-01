//
//  SearchView.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("GitHub")
                .searchable(text: $viewModel.query, prompt: "Repositories")
                .onChange(of: viewModel.query) {
                    viewModel.queryDidChange()
                }
                .onSubmit(of: .search) {
                    Task { await viewModel.searchNow() }
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .navigationDestination(for: Repository.self) { repository in
                    RepositoryDetailView(repository: repository)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                "Search GitHub",
                systemImage: "magnifyingglass",
                description: Text("Find repositories by name, language, or topic.")
            )

        case .loading:
            ProgressView("Searching")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView.search(text: viewModel.query)

        case .failed(let message):
            ContentUnavailableView {
                Label("Search failed", systemImage: "wifi.slash")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.searchNow() }
                }
            }

        case .results(let repositories):
            RepositoryListView(
                repositories: repositories,
                refreshError: viewModel.refreshError,
                isSearching: viewModel.isSearching
            )
        }
    }
}

#Preview {
    let dependencies = AppDependencies.preview()
    SearchView(viewModel: dependencies.searchViewModel)
        .environment(\.imageLoader, dependencies.imageLoader)
}
