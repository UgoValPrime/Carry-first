//
//  ProductListViewModelTests.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.
//

import XCTest
import Combine
@testable import Carry1stEcommerceApp

final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var mockRepository: MockProductRepository!
    var mockCache: MockProductCache!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductRepository()
        mockCache = MockProductCache()
        viewModel = ProductListViewModel(productRepository: mockRepository, productCache: mockCache)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockCache = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchProductsFromCacheSuccess() {
        // Arrange
        let cachedProducts = [Product(id: 1, name: "Test Product", description: "Description", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 5, imageLocation: "url", status: "Available")]
        mockCache.stubbedFetchProducts = cachedProducts

        // Act
        viewModel.loadProducts()

        // Assert
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.name, "Test Product")
    }

    func testFetchProductsFromRepositorySuccess() {
        // Arrange
        mockCache.stubbedFetchProducts = nil // No cached products
        let fetchedProducts = [Product(id: 1, name: "Repository Product", description: "Description", price: 20.0, currencyCode: "USD", currencySymbol: "$", quantity: 10, imageLocation: "url", status: "Available")]
        mockRepository.stubbedFetchProductsResult = Just(fetchedProducts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        // Act
        viewModel.loadProducts()

        // Assert
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.name, "Repository Product")
    }

    func testFetchProductsFromRepositoryFailure() {
        // Arrange
        mockCache.stubbedFetchProducts = nil
        mockRepository.stubbedFetchProductsResult = Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()

        // Act
        viewModel.loadProducts()

        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.products.count, 0)
    }
}

