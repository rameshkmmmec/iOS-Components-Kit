//
//  UIView+Extensions.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit


extension UIView {
    
    struct CornerPositions: OptionSet {
        let rawValue: Int
        
        static let topLeft     = CornerPositions(rawValue: 1 << 0)
        static let topRight    = CornerPositions(rawValue: 1 << 1)
        static let bottomLeft  = CornerPositions(rawValue: 1 << 2)
        static let bottomRight = CornerPositions(rawValue: 1 << 3)
        
        static let top: CornerPositions    = [.topLeft, .topRight]
        static let bottom: CornerPositions = [.bottomLeft, .bottomRight]
        static let left: CornerPositions   = [.topLeft, .bottomLeft]
        static let right: CornerPositions  = [.topRight, .bottomRight]
        static let all: CornerPositions    = [.top, .bottom]
        
        var caCornerMask: CACornerMask {
            var mask: CACornerMask = []
            if contains(.topLeft)     { mask.insert(.layerMinXMinYCorner) }
            if contains(.topRight)    { mask.insert(.layerMaxXMinYCorner) }
            if contains(.bottomLeft)  { mask.insert(.layerMinXMaxYCorner) }
            if contains(.bottomRight) { mask.insert(.layerMaxXMaxYCorner) }
            return mask
        }
    }
    
    /// Selectively rounds specified corners using CoreAnimation maskedCorners.
    /// - Parameters:
    ///   - corners: Set of corners to round (e.g. `.top`, `.bottom`, `[.topLeft, .bottomRight]`)
    ///   - radius: Corner radius value.
    func roundCorners(_ corners: CornerPositions, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners.caCornerMask
        self.clipsToBounds = true
    }
}
