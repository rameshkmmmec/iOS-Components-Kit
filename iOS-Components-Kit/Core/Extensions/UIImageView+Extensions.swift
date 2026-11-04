//
//  UIImageView+Extensions.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit
import ObjectiveC

private var taskKey: UInt8 = 0

extension UIImageView {
    private var currentTask: Task<Void, Never>? {
        get { objc_getAssociatedObject(self, &taskKey) as? Task<Void, Never> }
        set { objc_setAssociatedObject(self, &taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Image URL se asynchronously load karta hai, cache check karta hai, aur task cancellation handle karta hai
    func setImage(
        from urlString: String?,
        placeholder: UIImage? = nil
    ) {
        // 1. Purana running task cancel karein
        currentTask?.cancel()
        currentTask = nil

        // 2. Placeholder set karein
        self.image = placeholder

        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }

        // 3. Agar image cache me pehle se hai toh direct use karein
        if let cachedImage = ImageCacheManager.shared.image(for: url) {
            self.image = cachedImage
            return
        }

        // 4. Background network task shuru karein
        currentTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // Agar task cancel ho gaya toh stop karein
                guard !Task.isCancelled else { return }

                if let downloadedImage = UIImage(data: data) {
                    // Cache me save karein
                    ImageCacheManager.shared.insert(downloadedImage, for: url)

                    // UI update main thread par
                    await MainActor.run {
                        guard let self = self else { return }
                        self.image = downloadedImage
                    }
                }
            } catch {
                // Network fail hone par placeholder retain rahega
            }
        }
    }

    /// Explicit cancellation (e.g. prepareForReuse me call karne ke liye)
    func cancelImageLoad() {
        currentTask?.cancel()
        currentTask = nil
    }
}
