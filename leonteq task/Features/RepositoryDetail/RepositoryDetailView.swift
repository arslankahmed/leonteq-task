//
//  RepositoryDetailView.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository

    var body: some View {
        List {
            Section {
                header
            }

            if let summary = repository.summary, !summary.isEmpty {
                Section("About") {
                    Text(summary)
                }
            }

            Section("Details") {
                LabeledContent("Stars", value: repository.stargazersCount.formatted())
                LabeledContent("Forks", value: repository.forksCount.formatted())
                LabeledContent("Open issues", value: repository.openIssuesCount.formatted())
                if let language = repository.language {
                    LabeledContent("Language", value: language)
                }
            }

            Section {
                Link(destination: repository.htmlURL) {
                    Label("Open in Safari", systemImage: "safari")
                }
            }
        }
        .navigationTitle(repository.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack(spacing: 12) {
            OwnerAvatar(url: repository.owner.avatarURL, size: 64)

            VStack(alignment: .leading, spacing: 4) {
                Text(repository.fullName)
                    .font(.headline)
                Text(repository.owner.login)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let dependencies = AppDependencies.preview()
    NavigationStack {
        RepositoryDetailView(repository: .preview)
    }
    .environment(\.imageLoader, dependencies.imageLoader)
}

#Preview("Dark") {
    let dependencies = AppDependencies.preview()
    NavigationStack {
        RepositoryDetailView(repository: .preview)
    }
    .environment(\.imageLoader, dependencies.imageLoader)
    .preferredColorScheme(.dark)
}
