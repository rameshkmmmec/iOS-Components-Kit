//
//  GridItem.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

nonisolated enum GridItem: Hashable {
    case banner(BannerModel)
    case category(CategoryModel)
    case asset(AssetModel)
}
