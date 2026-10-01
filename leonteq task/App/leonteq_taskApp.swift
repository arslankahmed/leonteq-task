//
//  leonteq_taskApp.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI

@main
struct leonteq_taskApp: App {
    private let dependencies = AppDependencies.live()

    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: dependencies.searchViewModel)
                .environment(\.imageLoader, dependencies.imageLoader)
        }
    }
}
