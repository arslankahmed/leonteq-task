//
//  HTTPError.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

enum HTTPError: Error, Equatable, LocalizedError {
    case invalidURL
    case invalidResponse
    case transport
    case statusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL, .invalidResponse:
            return "Couldn't complete the request."
        case .transport:
            return "No internet connection."
        case .statusCode(403), .statusCode(429):
            return "Too many requests. Wait a minute and try again."
        case .statusCode(let code):
            return "Request failed (\(code))."
        }
    }
}
