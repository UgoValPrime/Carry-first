//
//  ProductListRowView.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import SwiftUI
import Kingfisher

struct ProductListRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            KFImage(URL(string: product.imageLocation))
                .placeholder {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("$\(product.price)")
                    .font(.subheadline)
            }
        }
    }
}

