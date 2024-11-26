//
//  ProductListView.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import SwiftUI
import Resolver

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel = Resolver.resolve()
    @EnvironmentObject var cartViewModel: CartViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Show a ProgressView when loading
                    VStack {
                        ProgressView("Loading Products...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Text("Please wait while we fetch the latest products.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    // Show an error message with a retry button
                    VStack(spacing: 16) {
                        Text("Failed to load products")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            viewModel.loadProducts() // Retry the API call
                        }) {
                            Text("Retry")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 40)
                    }
                } else {
                    // Show the list of products
                    List(viewModel.products) { product in
                        NavigationLink(value: product) {
                            ProductListRowView(product: product)
                        }
                    }
                    .navigationDestination(for: Product.self) { product in
                        ProductDetailsView(product: product)
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CartBadgeView()
                }
            }
        }
    }
}

#Preview {
    ProductListView()
}

