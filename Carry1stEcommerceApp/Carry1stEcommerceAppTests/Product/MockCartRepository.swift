//
//  MockCartRepository.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.
//

import XCTest
import Combine
@testable import Carry1stEcommerceApp

final class MockCartRepository: CartRepositoryProtocol {
    private(set) var cartItems: [Int: CartItem] = [:]
    var didCallAddToCart = false
    var didCallRemoveOneFromCart = false
    var didCallRemoveFromCart = false
    var didCallGetCartItems = false
    var didCallClearCart = false
    
    func addToCart(_ product: Product) {
        didCallAddToCart = true
        if let existingItem = cartItems[product.id] {
            cartItems[product.id]?.quantity += 1
        } else {
            cartItems[product.id] = CartItem(product: product, quantity: 1)
        }
    }

    func removeOneFromCart(_ product: Product) {
        didCallRemoveOneFromCart = true
        guard let existingItem = cartItems[product.id] else { return }
        if existingItem.quantity > 1 {
            cartItems[product.id]?.quantity -= 1
        } else {
            cartItems.removeValue(forKey: product.id)
        }
    }

    func removeFromCart(_ product: Product) {
        didCallRemoveFromCart = true
        cartItems.removeValue(forKey: product.id)
    }

    func getCartItems() -> [CartItem] {
        didCallGetCartItems = true
        return Array(cartItems.values)
    }

    func clearCart() {
        didCallClearCart = true
        cartItems.removeAll()
    }
}

