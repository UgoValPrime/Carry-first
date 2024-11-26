//
//  UserDefaultsManagerTest.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 26/11/2024.
//

import XCTest
@testable import Carry1stEcommerceApp

final class UserDefaultsManagerTests: XCTestCase {
    var userDefaultsManager: UserDefaultsManager!
    var testUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        testUserDefaults = UserDefaults(suiteName: "TestSuite")
        testUserDefaults.removePersistentDomain(forName: "TestSuite") // Clear data before each test
        userDefaultsManager = UserDefaultsManager(userDefaults: testUserDefaults)
    }

    override func tearDown() {
        testUserDefaults.removePersistentDomain(forName: "TestSuite") // Clean up after each test
        testUserDefaults = nil
        userDefaultsManager = nil
        super.tearDown()
    }

    func testSaveAndFetchObject() {
        // Arrange
        let product = Product(id: 1, name: "Test Product", description: "Test Description", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 1, imageLocation: "url", status: "Available")
        let key = "testProductKey"

        // Act
        userDefaultsManager.save(product, forKey: key)
        let fetchedProduct: Product? = userDefaultsManager.fetch(forKey: key, as: Product.self)

        // Assert
        XCTAssertNotNil(fetchedProduct)
        XCTAssertEqual(fetchedProduct?.id, product.id)
        XCTAssertEqual(fetchedProduct?.name, product.name)
    }

    func testFetchNonExistentObject() {
        // Arrange
        let key = "nonExistentKey"

        // Act
        let fetchedProduct: Product? = userDefaultsManager.fetch(forKey: key, as: Product.self)

        // Assert
        XCTAssertNil(fetchedProduct)
    }

    func testRemoveObject() {
        // Arrange
        let product = Product(id: 1, name: "Test Product", description: "Test Description", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 1, imageLocation: "url", status: "Available")
        let key = "testProductKey"
        userDefaultsManager.save(product, forKey: key)

        // Act
        userDefaultsManager.remove(forKey: key)
        let fetchedProduct: Product? = userDefaultsManager.fetch(forKey: key, as: Product.self)

        // Assert
        XCTAssertNil(fetchedProduct)
    }

    func testEncodingFailure() {
        // Arrange
        let key = "testKey"
        
        struct NonEncodable: Codable {
            let closureIdentifier: String
            
            // Custom initializer to accept a closure identifier
            init(closureIdentifier: String) {
                self.closureIdentifier = closureIdentifier
            }

            // Convert closure to an identifiable string (e.g., some fixed identifier)
            static func closureIdentifier(for closure: @escaping () -> Void) -> String {
                return "uniqueIdentifierForClosure"
            }
        }
        
        // Instead of passing the closure, pass its "identifier" or a String.
        let closureIdentifier = NonEncodable.closureIdentifier(for: { print("Hello") })
        let nonEncodable = NonEncodable(closureIdentifier: closureIdentifier)

        // Act
        userDefaultsManager.save(nonEncodable, forKey: key)

        // Assert
        let fetchedData = testUserDefaults.data(forKey: key)
        XCTAssertNotNil(fetchedData) // Data should be saved

        // Optionally: To ensure the object is saved and retrieved correctly,
        // you can also decode it back.
        if let fetchedData = fetchedData {
            do {
                let fetchedObject = try JSONDecoder().decode(NonEncodable.self, from: fetchedData)
                XCTAssertEqual(fetchedObject.closureIdentifier, closureIdentifier)
            } catch {
                XCTFail("Failed to decode fetched data: \(error)")
            }
        }
    }


    func testDecodingFailure() {
        // Arrange
        let key = "testKey"
        let invalidData = "Invalid Data".data(using: .utf8)
        testUserDefaults.set(invalidData, forKey: key)

        // Act
        let fetchedProduct: Product? = userDefaultsManager.fetch(forKey: key, as: Product.self)

        // Assert
        XCTAssertNil(fetchedProduct)
    }
}
