//
//  URLSessionHTTPClient.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: APIRequest) async throws -> Data {
        let urlRequest = try request.makeURLRequest()

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError where error.code == .cancelled {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw HTTPError.transport
        }

        guard let http = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw HTTPError.statusCode(http.statusCode)
        }

        return data
    }
}
