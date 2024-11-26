//
//  CartBadgeView.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import SwiftUI

struct CartBadgeView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showEmptyCartAlert = false
    @State private var showCartModal = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Cart image
            Image(systemName: "cart.fill")
                .resizable()
                .frame(width: 30, height: 30) // Size of the cart image
                .foregroundColor(.blue) // Optional: Color for the cart icon
                .onTapGesture {
                    if cartViewModel.isCartEmpty {
                        showEmptyCartAlert = true
                    } else {
                        showCartModal = true
                    }
                }

            // Badge view (count)
            if cartViewModel.cartItems.count > 0 {
                Text("\(cartViewModel.cartItems.count)")
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10) // Adjust position to overlap the corner
            }
        }
        .alert("Cart is empty", isPresented: $showEmptyCartAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showCartModal) {
            CartModalView()
                .environmentObject(cartViewModel)
        }
    }
}

#Preview {
    CartBadgeView()
        .environmentObject(CartViewModel(cartRepository: CartRepository(cartCache: CartCacheManager())))
}





struct CartModalView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showCheckoutSummary = false // Controls the summary modal

    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.cartItems.isEmpty {
                    Text("Your cart is empty!")
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        VStack{
                            ForEach(cartViewModel.cartItems, id: \.id) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.product.name)
                                            .font(.headline)
                                        Text("Price: $\(item.product.price, specifier: "%.2f")")
                                            .font(.subheadline)
                                        Text("Subtotal: $\(item.totalPrice, specifier: "%.2f")")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    HStack {
                                        // Decrease button
                                        Button(action: {
                                            print("minus button typed for \(item.product.name)")
                                            cartViewModel.decreaseQuantity(for: item.product)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.red)
                                                .padding() // Optional: Add padding to make the background larger
                                                .background(Color.yellow) // Yellow background
                                                .clipShape(Circle()) // Make the background circular
                                            
                                        }
                                        
                                        // Quantity display
                                        Text("\(item.quantity)")
                                            .padding(.horizontal, 8)
                                        // Increase button
                                        Button(action: {
                                            print("plus button typed for \(item.product.name)")
                                            cartViewModel.increaseQuantity(for: item.product)
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.green)
                                                .padding() // Optional: Add padding to make the background larger
                                                .background(Color.yellow) // Yellow background
                                                .clipShape(Circle()) // Make the background circular
                                            
                                            
                                        }
                                    }
                                }
                                //                            .id(item.id) // Ensure each item is uniquely identified
                            }
                        }
                        .padding()
                    }
                }

                HStack {
                    Text("Total: $\(cartViewModel.totalPrice, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button("Checkout") {
                        if cartViewModel.isCartEmpty {
                            print("Cart is empty.")
                        } else {
                            cartViewModel.checkout()
                            showCheckoutSummary = true // Show the summary modal
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCheckoutSummary) {
                CheckoutSummaryView(summary: cartViewModel.checkoutSummary)
            }
        }
    }
}


struct CheckoutSummaryView: View {
    let summary: String

    var body: some View {
        NavigationView {
            VStack {
                Text("Purchase Summary")
                    .font(.title)
                    .padding()

                ScrollView {
                    Text(summary)
                        .font(.body)
                        .padding()
                }

                Button("Done") {
                    // Close the modal
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.dismiss(animated: true, completion: nil)
                        }
                    }

                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
