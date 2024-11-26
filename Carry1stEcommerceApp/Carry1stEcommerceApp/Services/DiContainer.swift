//
//  DiContainer.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 21/11/2024.
//

import Foundation
import Resolver

extension Resolver {
    static func registerServices() {
        // Register Network Manager
        register { NetworkManager()}.scope(.application)

        // Register UserDefaults Manager
        register{UserDefaultsManager()}
        
        // Register Cache Managers
        register { ProductCacheManager() as ProductCacheProtocol }.scope(.application)
        register { CartCacheManager() as CartCacheProtocol }.scope(.application)

        // Register Repositories
        register {
            ProductRepository(networkManager: resolve(), productCache: resolve()) as ProductRepositoryProtocol
        }.scope(.application)

        register {
            CartRepository(cartCache: resolve()) as CartRepositoryProtocol
        }.scope(.application)

        // Register View Models
        register {
            ProductListViewModel(productRepository: resolve(), productCache: resolve())
        }

        register {
            CartViewModel(cartRepository: resolve())
        }
    }
}


