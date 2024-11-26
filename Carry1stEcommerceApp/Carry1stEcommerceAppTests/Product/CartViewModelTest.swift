//
//  CartViewModelTest.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.
//

import XCTest
import Combine
@testable import Carry1stEcommerceApp

final class CartViewModelTests: XCTestCase {
    var cartViewModel: CartViewModel!
    var mockCache: MockCartCache!
    var mockRepository: MockCartRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockCartRepository()
        mockCache = MockCartCache()
        cartViewModel = CartViewModel(cartRepository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        cartViewModel = nil
        mockCache = nil
        super.tearDown()
    }

    func testAddToCart() {
        // Arrange
        let product = Product(id: 1, name: "Test Product", description: "Description", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 1, imageLocation: "url", status: "Available")

        // Act
        cartViewModel.addToCart(product)

        // Assert
        XCTAssertEqual(cartViewModel.cartItems.count, 1)
        XCTAssertEqual(cartViewModel.cartItems.first?.quantity, 1)
    }

    func testRemoveFromCart() {
        // Arrange
        let product = Product(id: 1, name: "Test Product", description: "Description", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 1, imageLocation: "url", status: "Available")
        cartViewModel.addToCart(product)

        // Act
        cartViewModel.decreaseQuantity(for: product)

        // Assert
        XCTAssertEqual(cartViewModel.cartItems.count, 0)
    }
}
