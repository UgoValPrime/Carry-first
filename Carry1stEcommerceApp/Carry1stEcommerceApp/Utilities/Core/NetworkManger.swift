//
//  NetworkManger.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 22/11/2024.
//

import Foundation
import Combine

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}




class NetworkManager {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        Future { promise in
            let task = self.session.dataTask(with: URLRequest(url: url)) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let data = data else {
                    promise(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}

extension URLSession: URLSessionProtocol {}






