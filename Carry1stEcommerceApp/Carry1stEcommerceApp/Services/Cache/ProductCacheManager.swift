//
//  ProductCacheManager.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 24/11/2024.
//

import Foundation

protocol ProductCacheProtocol {
    func fetchProducts() -> [Product]?
    func saveProducts(_ products: [Product])
    func clearCache()
}

class ProductCacheManager: ProductCacheProtocol {
    private let userDefaultsManager: UserDefaultsManager
    private let cacheExpirationInterval: TimeInterval = 3600 // 1 hour in seconds
    private let cacheKey = "ProductCache"
    private let lastUpdatedKey = "ProductCacheLastUpdated"

    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func fetchProducts() -> [Product]? {
        guard let lastUpdated = userDefaultsManager.fetch(forKey: lastUpdatedKey, as: Date.self) else {
            print("No cache exists.")
            return nil
        }

        // Check cache validity
        let timeElapsed = Date().timeIntervalSince(lastUpdated)
        if timeElapsed > cacheExpirationInterval {
            print("Cache expired. Clearing cache...")
            clearCache()
            return nil
        }

        let cachedProducts: [Product]? = userDefaultsManager.fetch(forKey: cacheKey, as: [Product].self)
        print(cachedProducts != nil ? "Returning cached products." : "No products found in cache.")
        return cachedProducts
    }

    func saveProducts(_ products: [Product]) {
        clearCache() // Clear existing cache
        userDefaultsManager.save(products, forKey: cacheKey)
        userDefaultsManager.save(Date(), forKey: lastUpdatedKey)
        print("Products saved to cache. Last updated: \(Date())")
    }

    func clearCache() {
        userDefaultsManager.remove(forKey: cacheKey)
        userDefaultsManager.remove(forKey: lastUpdatedKey)
        print("Product cache cleared.")
    }
}
