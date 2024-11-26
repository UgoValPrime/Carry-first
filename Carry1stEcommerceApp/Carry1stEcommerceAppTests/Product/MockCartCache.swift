//
//  MockCartCache.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.
//

import XCTest

import Foundation
@testable import Carry1stEcommerceApp

final class MockCartCache: CartCacheProtocol {
   

    var stubbedCartItems: [CartItem] = []
    var didCallSaveCartItems = false
    var didCallClearCart = false

    func fetchCartItems() -> [CartItem]? {
        return stubbedCartItems
    }

    func saveCartItems(_ cartItems: [CartItem]) {
        didCallSaveCartItems = true
        stubbedCartItems = cartItems
    }

    func clearCartItems() {
        didCallClearCart = true
        stubbedCartItems = []
    }
}

