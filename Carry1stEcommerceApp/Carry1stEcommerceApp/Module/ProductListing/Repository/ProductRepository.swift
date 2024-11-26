//
//  ProductRepository.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import Foundation
import Combine


protocol ProductRepositoryProtocol {
    func fetchProducts() -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryProtocol {
    private let networkManager: NetworkManager
    private let productCache: ProductCacheProtocol

    // Dependency injection for NetworkManager and ProductCache
    init(networkManager: NetworkManager, productCache: ProductCacheProtocol) {
        self.networkManager = networkManager
        self.productCache = productCache
        print("ProductRepository initialized with network manager: \(networkManager) and cache: \(productCache)")
    }

    func fetchProducts() -> AnyPublisher<[Product], Error> {
        print("Attempting to fetch products...")

        // Check if cached products are available
        if let cachedProducts = productCache.fetchProducts() {
            print("Returning cached products")
            return Just(cachedProducts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        // If not, fetch from network
        guard let url = URL(string: "https://my-json-server.typicode.com/carry1stdeveloper/mock-product-api/productBundles") else {
            print("Invalid URL")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        print("Fetching products from network at URL: \(url)")
        return networkManager.fetch(from: url)
            .handleEvents(receiveOutput: { [weak self] products in
                // Save fetched products to cache
                self?.productCache.saveProducts(products)
                print("Products cached successfully.")
            })
            .eraseToAnyPublisher()
    }
}


