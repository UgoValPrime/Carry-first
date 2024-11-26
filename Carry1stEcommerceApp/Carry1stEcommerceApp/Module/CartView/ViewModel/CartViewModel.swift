//
//  CartViewModel.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import Foundation
import Combine


class CartViewModel: ObservableObject {
    private let cartRepository: CartRepositoryProtocol

    @Published var cartItems: [CartItem] = []
    @Published var totalPrice: Double = 0.0
    @Published var purchasedItems: [CartItem] = [] // Track what was purchased
    @Published var purchasedTotalPrice: Double = 0.0 // Track total cost of purchased items
    @Published var checkoutSummary: String = "" // A formatted summary of purchased items

    init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
        updateCartItems()
    }

    var isCartEmpty: Bool {
        cartItems.isEmpty
    }

    func addToCart(_ product: Product) {
        cartRepository.addToCart(product)
        updateCartItems()
    }

    func increaseQuantity(for product: Product) {
        addToCart(product) // Reuse logic from `addToCart`
    }

    func decreaseQuantity(for product: Product) {
        cartRepository.removeOneFromCart(product)
        updateCartItems()
    }

    func clearCart() {
        cartRepository.clearCart()
        updateCartItems()
    }

    func checkout() {
        purchasedItems = cartItems // Record purchased items
        purchasedTotalPrice = totalPrice // Record the total price

        // Generate a detailed summary
        checkoutSummary = purchasedItems.map { item in
            "\(item.quantity) × \(item.product.name) @ $\(item.product.price) = $\(item.totalPrice)"
        }.joined(separator: "\n")

        // Append total price to the summary
        checkoutSummary += "\n\nTotal: $\(purchasedTotalPrice)"

        // Clear cart after checkout
        clearCart()

        print("Checkout successful! Purchased items:")
        print(checkoutSummary)
    }

    private func updateCartItems() {
        let items = cartRepository.getCartItems()
        cartItems = items
        totalPrice = cartItems.reduce(0) { $0 + $1.totalPrice }
    }
}



import Foundation

struct CartItem: Identifiable, Codable {
    let id: UUID
    let product: Product
    var quantity: Int

    init(product: Product, quantity: Int) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
    }

    var totalPrice: Double {
        Double(quantity) * product.price
    }
    
    // MARK: - Custom Encoding and Decoding for Product
    enum CodingKeys: String, CodingKey {
        case id, product, quantity
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        product = try container.decode(Product.self, forKey: .product)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }

    // Custom encoding method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(product, forKey: .product)
        try container.encode(quantity, forKey: .quantity)
    }
}


