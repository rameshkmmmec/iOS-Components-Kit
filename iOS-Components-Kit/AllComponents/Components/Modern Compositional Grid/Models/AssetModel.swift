//
//  AssetModel.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

nonisolated struct AssetModel: Hashable {
    let id = UUID()
    let title: String
    let categoryId: String
    let priceTag: String
    let imageURL: String
}
