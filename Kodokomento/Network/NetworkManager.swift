//
//  NetworkManager.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 01/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol NetworkManagerType {
    func call<T: Decodable>(router: NetworkRouter, result: @escaping NetworkResult<T>)
}

public struct NetworkManager {
    fileprivate let _configuration: URLSessionConfiguration
    fileprivate let _session: URLSession

    init(with configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        _configuration = configuration

        _session = URLSession(configuration: _configuration,
                              delegate: nil,
                              delegateQueue: nil)
    }

    func log(request: URLRequest, data: Data?, response: HTTPURLResponse?, error: NSError?) {
        if
            let data = data,
            let response = response,
            let url = request.url,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            print("\n")
            print("\(200 ... 300 ~= response.statusCode ? "💬" : "⚠️") :: Request URL: \(url) :: Response Code: \(response.statusCode)")
            print("Response: \n\(json)")
            print("\n")

        } else {
            if
                let error = error,
                let url = request.url {
                print("\n")
                print("🚫 :: Request URL: \(url) :: Error Code: \(error.code)")
                print("Error Description: \n\(error.description)")
                print("\n")
            }
        }
    }
}

extension NetworkManager: NetworkManagerType {
    func call<T: Decodable>(router: NetworkRouter, result: @escaping NetworkResult<T>) {
        let request = router.request()

        _session.dataTask(with: request) { data, response, error in

            self.log(request: request,
                     data: data,
                     response: response as? HTTPURLResponse,
                     error: error as NSError?)

            if
                let data = data,
                let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200 ... 300:

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                    if let decodable = try? JSONDecoder().decode(T.self, from: data) {
                        result(.success(decodable))
                    } else {
                        result(.failure(.parseError))
                    }

                case 401 ... 404:
                    result(.failure(.unauthorized))

                default:
                    result(.failure(.general))
                }

            } else {
                if let error = error as NSError? {
                    switch error.code {
                    case -1009:
                        result(.failure(.noNetwork))

                    case -1001:
                        result(.failure(.requestTimeout))

                    default:
                        result(.failure(.general))
                    }
                }
            }

        }.resume()
    }
}

typealias NetworkResult<U> = (NetworkResponse<U>) -> Void

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Error {
    case general
    case parseError
    case coded(code: String)
    case noNetwork
    case requestTimeout
    case unauthorized
}
