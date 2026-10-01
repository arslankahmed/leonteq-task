//
//  ImageLoadingEnvironment.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

private struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue: (any ImageLoading)? = nil
}

extension EnvironmentValues {
    var imageLoader: (any ImageLoading)? {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self] = newValue }
    }
}
