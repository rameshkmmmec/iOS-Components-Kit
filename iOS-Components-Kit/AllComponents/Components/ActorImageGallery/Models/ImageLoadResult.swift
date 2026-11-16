//
//  ImageLoadResult.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

enum ImageCacheSource: String {
    case memory = "Memory Cache"
    case disk = "Disk Cache"
    case network = "Network"
}

struct ImageLoadResult {
    let image: UIImage
    let source: ImageCacheSource
    let durationMs: Double
}
