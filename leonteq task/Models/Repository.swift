//
//  Repository.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct Repository: Identifiable, Hashable, Decodable, Sendable {
    let id: Int
    let name: String
    let fullName: String
    let summary: String?
    let htmlURL: URL
    let stargazersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String?
    let owner: Owner

    struct Owner: Hashable, Decodable, Sendable {
        let login: String
        let avatarURL: URL

        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case summary = "description"
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case language
        case owner
    }
}
