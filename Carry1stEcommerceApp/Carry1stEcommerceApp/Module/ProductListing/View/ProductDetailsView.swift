//
//  ProductDetailsView.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import SwiftUI


struct ProductDetailsView: View {
    let product: Product

    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showBuyNowModal = false
    @State private var showAddedToCartAlert = false // State for alert visibility

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Alert at the top
                if showAddedToCartAlert {
                    Text("Product added to cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut(duration: 0.3), value: showAddedToCartAlert)
                        .onAppear {
                            // Dismiss the alert after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showAddedToCartAlert = false
                            }
                        }
                }

                AsyncImage(url: URL(string: product.imageLocation)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)

                Text(product.name)
                    .font(.largeTitle)
                    .bold()

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)

                Text(product.description)
                    .font(.body)
                    .padding()

                HStack {
                    Button("Add to Cart") {
                        cartViewModel.addToCart(product)
                        showAddedToCartAlert = true // Show the alert when the product is added
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Buy Now") {
                        showBuyNowModal = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle(product.name)
        .sheet(isPresented: $showBuyNowModal) {
            BuyNowModalView(product: product)
        }
    }
}



//#Preview {
//    let mockProduct = Product(
//        id: 1,
//        name: "Sample Product",
//        price: 99.99,
//        logo: "https://via.placeholder.com/200",
//        description: "This is a sample product for testing the ProductDetailsView."
//    )
//    
//    let cartViewModel = CartViewModel()
//    
//    ProductDetailsView(product: mockProduct)
//        .environmentObject(cartViewModel)
//}


import SwiftUI

struct BuyNowModalView: View {
    let product: Product

    @Environment(\.presentationMode) var presentationMode
    @State private var quantity = 1
    @State private var totalPrice: Double

    init(product: Product) {
        self.product = product
        _totalPrice = State(initialValue: product.price)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: product.imageLocation)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)

                Text(product.name)
                    .font(.headline)

                Text("Price: $\(product.price, specifier: "%.2f")")
                    .font(.subheadline)

                Stepper(value: $quantity, in: 1...100, step: 1) {
                    Text("Quantity: \(quantity)")
                }
                .onChange(of: quantity) { oldQuantity, newQuantity in
                    totalPrice = Double(newQuantity) * product.price
                }

                Text("Total Price: $\(totalPrice, specifier: "%.2f")")
                    .font(.title2)
                    .bold()

                Spacer()

                Button(action: completePurchase) {
                    Text("Complete Purchase")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Buy Now")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func completePurchase() {
        // Dummy completion logic
        print("Purchased \(quantity) x \(product.name) for $\(totalPrice)")
        presentationMode.wrappedValue.dismiss()
    }
}

//#Preview {
//    BuyNowModalView(product: Product(id: 1, name: "Sample", description: "Sample Description", price: 10.99, imageLocation: "https://via.placeholder.com/150"))
//}
