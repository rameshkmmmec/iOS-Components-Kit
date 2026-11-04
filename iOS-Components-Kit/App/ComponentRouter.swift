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
    
    static func destination() -> UIViewController {
        
        switch selectedComponent {
        case "CombineMVVMNetworking":
            return CryptoListController()
        default:
            return AllComponentsViewController()
        }
        
    }
}
