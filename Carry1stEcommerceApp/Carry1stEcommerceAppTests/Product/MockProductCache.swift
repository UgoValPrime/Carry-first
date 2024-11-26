//
//  MockProductCache.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 25/11/2024.

import Foundation
@testable import Carry1stEcommerceApp

final class MockProductCache: ProductCacheProtocol {
    var stubbedFetchProducts: [Product]?
    var didCallSaveProducts = false
    var didCallClearCache = false

    func fetchProducts() -> [Product]? {
        return stubbedFetchProducts
    }

    func saveProducts(_ products: [Product]) {
        didCallSaveProducts = true
    }

    func clearCache() {
        didCallClearCache = true
    }
}

