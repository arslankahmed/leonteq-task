//
//  ImageRequest.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import Foundation

struct ImageRequest: APIRequest {
    let url: URL

    var baseURL: URL { url }
}
