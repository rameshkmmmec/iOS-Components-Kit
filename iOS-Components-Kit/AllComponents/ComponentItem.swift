//
//  ComponentItem.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

struct ComponentItem: Hashable {
    
    let routeKey: String
    let title: String
    let subtitle: String
    let techStack: [String]
    let iconName: String
    let accentColor: UIColor
    
    static let allItems: [ComponentItem] = [
        
        ComponentItem(routeKey: "CombineMVVMNetworking",
                      title: "Combine+MVVM+Networking",
                      subtitle: "CoinGecko API list with generic Combine/async network wrapper",
                      techStack: ["UIKit", "Combine", "MVVM", "Async/Publisher"],
                      iconName: "list.bullet.rectangle.portrait.fill",
                      accentColor: .systemIndigo),
        
        ComponentItem(routeKey: "ActorImageCache",
                      title: "Actor Image Cache",
                      subtitle: "Thread-safe memory & disk caching with in-flight request deduplication",
                      techStack: ["Swift Concurrency", "Actor", "NSCache", "CryptoKit"],
                      iconName: "photo.stack.fill",
                      accentColor: .systemTeal),
        
        ComponentItem(
            routeKey: "ModernCompositionalGrid",
            title: "Compositional Layout & Diffable Grid",
            subtitle: "Multi-section orthogonal carousel, filter chips & animated DiffableDataSource",
            techStack: ["CompositionalLayout", "DiffableDataSource", "CellRegistration"],
            iconName: "square.grid.3x3.topleft.filled",
            accentColor: .systemPurple)
    ]
}
