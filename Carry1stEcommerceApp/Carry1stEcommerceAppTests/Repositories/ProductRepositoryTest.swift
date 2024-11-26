//
//  ProductRepositoryTest.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 26/11/2024.
//


import XCTest
import Combine
@testable import Carry1stEcommerceApp

final class ProductRepositoryTests: XCTestCase {
    var productRepository: MockProductRepository!
    var sampleProducts: [Product]!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        productRepository = MockProductRepository()
        sampleProducts = [
            Product(id: 1, name: "Product 1", description: "Desc 1", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 1, imageLocation: "url1", status: "Available"),
            Product(id: 2, name: "Product 2", description: "Desc 2", price: 20.0, currencyCode: "USD", currencySymbol: "$", quantity: 2, imageLocation: "url2", status: "Out of Stock")
        ]
        cancellables = []
    }

    override func tearDown() {
        productRepository = nil
        sampleProducts = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchProductsSuccess() {
        // Arrange
        productRepository.stubbedFetchProductsResult = Just(sampleProducts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Act & Assert
        productRepository.fetchProducts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { products in
                XCTAssertEqual(products.count, 2)
                XCTAssertEqual(products.first?.name, "Product 1")
            })
            .store(in: &cancellables)
    }

    func testFetchProductsFailure() {
        // Arrange
        let error = URLError(.notConnectedToInternet)
        productRepository.stubbedFetchProductsResult = Fail(error: error).eraseToAnyPublisher()
        
        // Act & Assert
        productRepository.fetchProducts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
                }
            }, receiveValue: { products in
                XCTFail("Expected failure but got products: \(products)")
            })
            .store(in: &cancellables)
    }
}
