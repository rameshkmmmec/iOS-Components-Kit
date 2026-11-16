//
//  CategoryModel.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

nonisolated struct CategoryModel: Hashable {
    let id: String
    let name: String
    let icon: String
    var isSelected: Bool
}
