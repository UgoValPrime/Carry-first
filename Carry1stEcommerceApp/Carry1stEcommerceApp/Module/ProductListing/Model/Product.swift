//
//  Product.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import Foundation

struct Product: Identifiable,Codable, Hashable {
    var id: Int
    var name, description: String
    var price: Double
    var currencyCode, currencySymbol: String
    var quantity: Int
    var imageLocation: String
    var status: String
}
