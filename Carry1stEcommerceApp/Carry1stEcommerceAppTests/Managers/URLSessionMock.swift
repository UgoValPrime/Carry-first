//
//  URLSessionMock.swift
//  Carry1stEcommerceAppTests
//
//  Created by GIGL-IT on 26/11/2024.
//

import XCTest
@testable import Carry1stEcommerceApp

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    static var shared: URLSessionMock!

    init() {
        URLSessionMock.shared = self
    }

    // The completionHandler needs to be @escaping since this is an async call
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}
