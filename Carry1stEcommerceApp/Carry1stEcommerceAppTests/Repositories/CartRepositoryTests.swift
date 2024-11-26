//
//  CartRepositoryTests.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 26/11/2024.
//

import XCTest
import Combine
@testable import Carry1stEcommerceApp

final class CartRepositoryTests: XCTestCase {
    var cartRepository: CartRepository!
    var mockCartCache: MockCartCache!
    var sampleProduct: Product!
    
    override func setUp() {
        super.setUp()
        mockCartCache = MockCartCache()
        cartRepository = CartRepository(cartCache: mockCartCache)
        sampleProduct = Product(
            id: 1,
            name: "Test Product",
            description: "Sample Description",
            price: 10.0,
            currencyCode: "USD",
            currencySymbol: "$",
            quantity: 1,
            imageLocation: "sample_url",
            status: "Available"
        )
    }

    override func tearDown() {
        cartRepository = nil
        mockCartCache = nil
        sampleProduct = nil
        super.tearDown()
    }

    func testAddToCart() {
        // Act
        cartRepository.addToCart(sampleProduct)
        
        // Assert
        let cartItems = cartRepository.getCartItems()
        XCTAssertEqual(cartItems.count, 1)
        XCTAssertEqual(cartItems.first?.product.name, "Test Product")
        XCTAssertEqual(cartItems.first?.quantity, 1)
    }

    func testRemoveOneFromCart() {
        // Arrange
        cartRepository.addToCart(sampleProduct)
        cartRepository.addToCart(sampleProduct) // Quantity = 2
        
        // Act
        cartRepository.removeOneFromCart(sampleProduct)
        
        // Assert
        let cartItems = cartRepository.getCartItems()
        XCTAssertEqual(cartItems.count, 1)
        XCTAssertEqual(cartItems.first?.quantity, 1)
    }

    func testRemoveFromCart() {
        // Arrange
        cartRepository.addToCart(sampleProduct)
        
        // Act
        cartRepository.removeFromCart(sampleProduct)
        
        // Assert
        XCTAssertTrue(cartRepository.getCartItems().isEmpty)
    }

    func testClearCart() {
        // Arrange
        cartRepository.addToCart(sampleProduct)
        cartRepository.addToCart(sampleProduct)
        
        // Act
        cartRepository.clearCart()
        
        // Assert
        XCTAssertTrue(cartRepository.getCartItems().isEmpty)
    }
}
