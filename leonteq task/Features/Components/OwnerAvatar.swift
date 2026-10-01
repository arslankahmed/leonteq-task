//
//  OwnerAvatar.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import SwiftUI
import UIKit

struct OwnerAvatar: View {
    let url: URL
    var size: CGFloat = 44

    @Environment(\.imageLoader) private var imageLoader
    @State private var image: UIImage?

    var body: some View {
        avatar
            .frame(width: size, height: size)
            .background(Color(.secondarySystemFill))
            .clipShape(Circle())
            .task(id: url) {
                await loadImage()
            }
    }

    @ViewBuilder
    private var avatar: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundStyle(.tertiary)
        }
    }

    private func loadImage() async {
        guard let imageLoader else { return }

        image = imageLoader.cachedImage(for: url)
        guard image == nil else { return }

        let loaded = await imageLoader.image(for: url)
        guard !Task.isCancelled else { return }
        image = loaded
    }
}
