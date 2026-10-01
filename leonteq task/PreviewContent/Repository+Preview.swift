//
//  Repository+Preview.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

#if DEBUG
extension Repository {
    static let preview = Repository(
        id: 44838949,
        name: "swift",
        fullName: "swiftlang/swift",
        summary: "The Swift Programming Language",
        htmlURL: URL(string: "https://github.com/swiftlang/swift")!,
        stargazersCount: 68_000,
        forksCount: 10_500,
        openIssuesCount: 6_200,
        language: "C++",
        owner: Owner(
            login: "swiftlang",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!
        )
    )
}
#endif
