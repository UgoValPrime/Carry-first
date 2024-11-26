//
//  CartCacheManager.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 24/11/2024.
//

import Foundation
import Foundation

protocol CartCacheProtocol {
    func fetchCartItems() -> [CartItem]?
    func saveCartItems(_ items: [CartItem])
    func clearCartItems()
}

class CartCacheManager: CartCacheProtocol {
    private let userDefaultsManager: UserDefaultsManager
    private let cacheKey = "cartItems"

    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Fetch Cart Items
    func fetchCartItems() -> [CartItem]? {
        let items: [CartItem]? = userDefaultsManager.fetch(forKey: cacheKey, as: [CartItem].self)
        if let items = items {
            print("Fetched \(items.count) cart items from cache.")
        } else {
            print("No cart items found in cache.")
        }
        return items
    }

    // MARK: - Save Cart Items to Cache
    func saveCartItems(_ items: [CartItem]) {
        userDefaultsManager.save(items, forKey: cacheKey)
        print("\(items.count) cart items saved to cache.")
    }

    // MARK: - Clear Cart Items from Cache
    func clearCartItems() {
        userDefaultsManager.remove(forKey: cacheKey)
        print("Cart items cache cleared.")
    }
}
