//
//  ProductListViewModel.swift
//  Carry1stEcommerceApp
//  Created by GIGL-IT on 22/11/2024.
//


import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productRepository: ProductRepositoryProtocol
    private let productCache: ProductCacheProtocol
    private var cancellables = Set<AnyCancellable>()

    init(productRepository: ProductRepositoryProtocol, productCache: ProductCacheProtocol) {
        self.productRepository = productRepository
        self.productCache = productCache
        loadProducts()
    }

    /// Fetch products from the cache or repository
    func loadProducts() {
        errorMessage = nil // Clear previous errors
        isLoading = true   // Show loading indicator

        // Check the cache first
        if let cachedProducts = productCache.fetchProducts() {
            DispatchQueue.main.async {
                self.products = cachedProducts
                self.isLoading = false
            }
            return
        }

        // If cache is empty, fetch from repository
        fetchProductsFromRepository()
    }

    /// Fetch products from the repository and update the cache
    private func fetchProductsFromRepository() {
        productRepository.fetchProducts()
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { products in
                DispatchQueue.main.async {
                    self.products = products
                    self.productCache.saveProducts(products)
                }
            })
            .store(in: &cancellables)
    }
}


