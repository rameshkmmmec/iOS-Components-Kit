//
//  GridSection.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

nonisolated enum GridSection: Int, CaseIterable, Hashable, Sendable {
    case featured
    case categories
    case items
    
    var title: String {
        switch self {
        case .featured:
            return "Featured Collections"
        case .categories:
            return "Categories"
        case .items:
            return "Trending Assets"
        }
    }
}
