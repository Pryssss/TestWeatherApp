//
//  Endpoint.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//
import Foundation

struct Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    let method: String
    let headers: [String: String]?
    let body: Data?

    var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Invalid URL components: \(components)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpBody = body
        return request
    }

    init(scheme: String = "https", host: String, path: String, queryItems: [URLQueryItem] = [], method: String = "GET") {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = nil
        self.body = nil
    }

    init(scheme: String = "https", host: String, path: String, queryItems: [URLQueryItem] = [], method: String = "GET", headers: [String: String]? = nil, body: Data? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = headers
        self.body = body
    }
}
