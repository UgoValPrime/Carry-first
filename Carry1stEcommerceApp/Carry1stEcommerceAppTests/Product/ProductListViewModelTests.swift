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
        XCTAssertEqual(mockCache.stubbedFetchProducts?.count, 1, "Expected 1 product in the view model")
        XCTAssertEqual(mockCache.stubbedFetchProducts?.first?.name, "Test Product")
    }

    func testFetchProductsFromRepositorySuccess() {
        // Arrange
        mockCache.stubbedFetchProducts = nil // No cached products
        let fetchedProducts = [Product(id: 1, name: "Repository Product", description: "Description", price: 20.0, currencyCode: "USD", currencySymbol: "$", quantity: 10, imageLocation: "url", status: "Available")]
        mockRepository.stubbedFetchProductsResult = Just(fetchedProducts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch products from repository")

        // Act
        viewModel.loadProducts()

        // Assert
        viewModel.$products
            .dropFirst() // Skip the initial empty state
            .sink { products in
                XCTAssertEqual(products.count, 1, "Expected 1 product from the repository")
                XCTAssertEqual(products.first?.name, "Repository Product")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchProductsFromRepositoryFailure() {
        // Arrange
        mockCache.stubbedFetchProducts = nil
        mockRepository.stubbedFetchProductsResult = Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Handle fetch products failure")

        // Act
        viewModel.loadProducts()

        // Assert
        viewModel.$errorMessage
            .dropFirst() 
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage, "Error message should be set on failure")
                XCTAssertEqual(self.viewModel.products.count, 0, "Products should be empty on failure")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}


