//
//  Carry1stEcommerceAppApp.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 21/11/2024.
//

import SwiftUI
import Resolver

@main
struct Carry1stEcommerceAppApp: App {
    init() {
        Resolver.registerServices()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ProductListView()
                .environmentObject(CartViewModel(cartRepository: Resolver.resolve()))
        }
    }
}
