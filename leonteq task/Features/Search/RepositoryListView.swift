//
//  RepositoryListView.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

struct RepositoryListView: View {
    let repositories: [Repository]
    let refreshError: String?
    let isSearching: Bool

    var body: some View {
        List {
            if isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }

            if let refreshError {
                Text(refreshError)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .listRowSeparator(.hidden)
            }

            ForEach(repositories) { repository in
                NavigationLink(value: repository) {
                    RepositoryRow(repository: repository)
                }
            }
        }
        .listStyle(.plain)
    }
}
