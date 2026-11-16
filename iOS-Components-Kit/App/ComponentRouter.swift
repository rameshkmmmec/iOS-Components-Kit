//
//  ComponentRouter.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit

enum ComponentRouter {
    
    static var selectedComponent: String {
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "-component"), arguments.indices.contains(index+1) {
            return arguments[index+1]
        }
        return "AllComponents"
    }
    
    // Scene Delegate launch argument support
    static func destination() -> UIViewController {
        return destination(for: selectedComponent)
    }
    
    // To Push from AllComponentsViewController
    static func destination(for key: String) -> UIViewController {
        
        switch key {
        case "CombineMVVMNetworking":
            return CryptoListController()
            
        case "ActorImageCache":
            return ActorImageCacheViewController()
            
        default:
            return AllComponentsViewController()
        }
        
    }
}
