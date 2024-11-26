//
//  MockProductRepository.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.

import Foundation
import Combine
@testable import Carry1stEcommerceApp

final class MockProductRepository: ProductRepositoryProtocol {
    var stubbedFetchProductsResult: AnyPublisher<[Product], Error>?

    func fetchProducts() -> AnyPublisher<[Product], Error> {
        return stubbedFetchProductsResult ?? Fail(error: URLError(.unknown)).eraseToAnyPublisher()
    }
}

