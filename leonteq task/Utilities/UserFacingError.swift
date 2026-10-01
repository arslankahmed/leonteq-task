//
//  UserFacingError.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

enum UserFacingError {
    static func message(for error: Error) -> String {
        if let httpError = error as? HTTPError {
            return httpError.localizedDescription
        }
        if error is DecodingError {
            return "Couldn't read the response from GitHub."
        }
        return "Something went wrong. Try again."
    }
}
