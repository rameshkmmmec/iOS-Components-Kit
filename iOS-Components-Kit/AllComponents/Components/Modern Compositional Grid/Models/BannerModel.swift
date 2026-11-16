//
//  BannerModel.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

nonisolated struct BannerModel: Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageURL: String
    let accentHex: UIColor
}
