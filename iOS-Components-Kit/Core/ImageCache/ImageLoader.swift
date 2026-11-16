//
//  ImageLoader.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit
import CryptoKit

actor ImageLoader {
    
    static let shared = ImageLoader()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private var inFlightTasks: [URL: Task<UIImage, Error>] = [:]
    private let fileManager = FileManager.default
    private let cacheDictionary: URL
    
    private init() {
        
        memoryCache.countLimit = 150
        memoryCache.totalCostLimit = 50 * 1024 * 1024
        
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDictionary = caches.appendingPathComponent("ActorImageCache", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDictionary, withIntermediateDirectories: true)
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        try await loadImageWithMetrices(from: url).image
    }
    
    func loadImageWithMetrices(from url:URL) async throws -> ImageLoadResult {
        
        let cacheKey = url.absoluteString as NSString
        let start = CFAbsoluteTimeGetCurrent()
        
        // 1. Memory cache check
        if let cachedImage = memoryCache.object(forKey: cacheKey) {
            let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
            return ImageLoadResult(image: cachedImage, source: .memory, durationMs: elapsed)
        }
        
        // 2. Disk cache check
        let diskPath = fileURL(for: url)
        if let diskData = try? Data(contentsOf: diskPath), let diskImage = UIImage(data: diskData) {
            memoryCache.setObject(diskImage, forKey: cacheKey)
            let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
            return ImageLoadResult(image: diskImage, source: .disk, durationMs: elapsed)
        }
        
        // 3. In-Flight Task Deduplication
        let task: Task<UIImage, Error>
        if let existingTask = inFlightTasks[url] {
            task = existingTask
            //return try await existingTask.value
        }else {
            // 4. Network Fetch Task
            let newTask = Task<UIImage, Error> {
                
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                      let image = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                
                // 5. Save to Memory & Disk
                memoryCache.setObject(image, forKey: cacheKey)
                try? data.write(to: diskPath, options: .atomic)
                return image
            }
            inFlightTasks[url] = newTask
            task = newTask
        }

        defer {
            inFlightTasks[url] = nil
        }
        let image = try await task.value
        let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
        return ImageLoadResult(image: image, source: .network, durationMs: elapsed)

    }
    
//    func loadImage(from url:URL) async throws -> UIImage {
//        
//        let cacheKey = url.absoluteString as NSString
//        
//        // 1. Memory cache check
//        if let cachedImage = memoryCache.object(forKey: cacheKey) {
//            return cachedImage
//        }
//        
//        // 2. Disk cache check
//        let diskPath = fileURL(for: url)
//        if let diskData = try? Data(contentsOf: diskPath), let diskImage = UIImage(data: diskData) {
//            memoryCache.setObject(diskImage, forKey: cacheKey)
//            return diskImage
//        }
//        
//        // 3. In-Flight Task Deduplication
//        if let existingTask = inFlightTasks[url] {
//            return try await existingTask.value
//        }
//        
//        // 4. Network Fetch Task
//        let task = Task<UIImage, Error> {
//            
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
//                  let image = UIImage(data: data) else {
//                throw URLError(.badServerResponse)
//            }
//            
//            // 5. Save to Memory & Disk
//            memoryCache.setObject(image, forKey: cacheKey)
//            try? data.write(to: diskPath, options: .atomic)
//            
//            return image
//        }
//        
//        inFlightTasks[url] = task
//        
//        defer {
//            inFlightTasks[url] = nil
//        }
//        return try await task.value
//
//    }
    
    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    func clearAllCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDictionary)
        try? fileManager.createDirectory(at: cacheDictionary, withIntermediateDirectories: true)
    }
    
    private func fileURL(for url:URL) -> URL {
        let hash = SHA256.hash(data: Data(url.absoluteString.utf8))
        let fileName = hash.compactMap { String(format: "%02x", $0)}.joined()
        return cacheDictionary.appendingPathComponent(fileName)
    }
}
