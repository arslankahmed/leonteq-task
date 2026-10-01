//
//  RepositoryRow.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

struct RepositoryRow: View {
    let repository: Repository

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            OwnerAvatar(url: repository.owner.avatarURL)

            VStack(alignment: .leading, spacing: 4) {
                Text(repository.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(repository.owner.login)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let summary = repository.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 8)

            Label(repository.stargazersCount.formatted(), systemImage: "star.fill")
                .labelStyle(.titleAndIcon)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.multicolor)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let dependencies = AppDependencies.preview()
    List {
        RepositoryRow(repository: .preview)
    }
    .environment(\.imageLoader, dependencies.imageLoader)
}
