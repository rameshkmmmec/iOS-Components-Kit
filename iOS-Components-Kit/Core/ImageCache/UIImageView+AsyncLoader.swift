//
//  UIImageView+AsyncLoader.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit
import ObjectiveC

private var imageLoadTaskKey: UInt8 = 0

@MainActor
extension UIImageView {
    
    private var currentLoadTask: Task<Void, Never>? {
        
        get { objc_getAssociatedObject(self, &imageLoadTaskKey) as? Task<Void, Never> }
        set { objc_setAssociatedObject(self, &imageLoadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setImag(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        
        // cancel previous running task on cell reuse
        currentLoadTask?.cancel()
        self.image = placeholder
        
        guard let urlString, let url = URL(string: urlString) else { return }
        
        currentLoadTask = Task { [weak self] in
        
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                guard !Task.isCancelled else { return }
                
                UIView.transition(with: self ?? UIImageView(), duration: 0.2, options: .transitionCrossDissolve) {
                    self?.image = image
                }
            } catch {
                // keep placeholder on failure or cancellation
            }
        }
        
    }
    
    func cancelImagLoad() {
        currentLoadTask?.cancel()
        currentLoadTask = nil
    }
}
