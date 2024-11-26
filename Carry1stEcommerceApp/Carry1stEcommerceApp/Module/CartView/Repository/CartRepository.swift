//
//  CartRepository.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import Foundation


protocol CartRepositoryProtocol {
    func addToCart(_ product: Product)
    func removeOneFromCart(_ product: Product)
    func removeFromCart(_ product: Product)
    func getCartItems() -> [CartItem]
    func clearCart()
}


class CartRepository: CartRepositoryProtocol {
    private var cartItems: [Int: CartItem] = [:]
    private let cartCache: CartCacheProtocol
    
    init(cartCache: CartCacheProtocol) {
        self.cartCache = cartCache
        // Load cached cart items if any
        if let cachedItems = cartCache.fetchCartItems() {
            self.cartItems = Dictionary(uniqueKeysWithValues: cachedItems.map { ($0.product.id, $0) })
        }
    }
    
    func addToCart(_ product: Product) {
        if let existingItem = cartItems[product.id] {
            cartItems[product.id]?.quantity += 1
        } else {
            cartItems[product.id] = CartItem(product: product, quantity: 1)
        }
        saveToCache()
    }

    func removeOneFromCart(_ product: Product) {
        guard let existingItem = cartItems[product.id] else { return }
        if existingItem.quantity > 1 {
            cartItems[product.id]?.quantity -= 1
        } else {
            cartItems.removeValue(forKey: product.id)
        }
        saveToCache()
    }

    func removeFromCart(_ product: Product) {
        cartItems.removeValue(forKey: product.id)
        saveToCache()
    }

    func getCartItems() -> [CartItem] {
        return Array(cartItems.values)
    }

    func clearCart() {
        cartItems.removeAll()
        cartCache.clearCartItems()
    }
    
    private func saveToCache() {
        cartCache.saveCartItems(Array(cartItems.values))
    }
}
