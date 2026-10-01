//
//  SearchViewState.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

enum SearchViewState: Equatable {
    case idle
    case loading
    case empty
    case results([Repository])
    case failed(String)
}
