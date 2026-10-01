//
//  ImageLoading.swift
//  leonteq task
//
//  Created by Arslan Ahmed on 01/10/2026.
//

import UIKit

protocol ImageLoading: AnyObject {
    func cachedImage(for url: URL) -> UIImage?
    func image(for url: URL) async -> UIImage?
}
