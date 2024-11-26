//
//  NetworkManagerTests.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 26/11/2024.
//

import XCTest
import Combine
import Foundation
@testable import Carry1stEcommerceApp

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
       var cancellables: Set<AnyCancellable>!

       override func setUp() {
           super.setUp()
           cancellables = []

           // Configure the custom URLSession
           let config = URLSessionConfiguration.default
           config.protocolClasses = [MockURLProtocol.self]
           let customSession = URLSession(configuration: config)

           // Inject the custom session into NetworkManager
           networkManager = NetworkManager(session: customSession)
       }

       override func tearDown() {
           networkManager = nil
           cancellables = nil
           super.tearDown()
       }
    
    func testFetch_SuccessfulResponse() {
        // Arrange
        let url = URL(string: "https://example.com/test")!
        let mockData = """
        {
            "id": 1,
            "name": "Test Product",
            "description": "Sample Description",
            "price": 10.0,
            "currencyCode": "USD",
            "currencySymbol": "$",
            "quantity": 1,
            "imageLocation": "sample_url",
            "status": "Available"
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.responseHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Fetch should succeed")
        
        networkManager.fetch(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { (product: Product) in
                XCTAssertEqual(product.name, "Test Product")
                XCTAssertEqual(product.price, 10.0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetch_ServerError() {
        // Arrange
        let url = URL(string: "https://example.com/test")!
        
        MockURLProtocol.responseHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, nil)
        }
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Fetch should fail with server error")
        
        networkManager.fetch(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }, receiveValue: { (_: Product) in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetch_NoData() {
        // Arrange
        let urlSessionMock = URLSessionMock()
        let networkManager = NetworkManager(session: urlSessionMock)
        let url = URL(string: "https://mockurl.com")!
        var receivedError: Error?

        let expectation = self.expectation(description: "Fetch should fail due to no data")

        // Mock a URLSession to trigger the "No Data" case
        urlSessionMock.data = nil as Data? // Explicit type for nil
        urlSessionMock.error = nil as Error? // Explicit type for nil
        
        networkManager.fetch(from: url)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { (_: Product) in
                XCTFail("Should not receive a product")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)

        // Assert
        XCTAssertNotNil(receivedError)
        let nsError = receivedError as? NSError
        XCTAssertEqual(nsError?.domain, "No Data")
    }

    
    func testFetch_DecodingError() {
        // Arrange
        let url = URL(string: "https://example.com/test")!
        let invalidData = """
        {
            "invalid_key": "Invalid Data"
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.responseHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidData)
        }
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Fetch should fail with decoding error")
        
        networkManager.fetch(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error is DecodingError)
                    expectation.fulfill()
                }
            }, receiveValue: { (_: Product) in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}





