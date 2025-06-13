//
//  Endpoint.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import Foundation

/// Represents a network API endpoint for any RESTful service.
/// Supports flexible construction of paths, queries, headers, and HTTP methods.
///
/// # Usage Example:
/// ```swift
/// // Simple GET request to weather API
/// let endpoint = Endpoint(
///     host: "api.open-meteo.com",
///     path: "/v1/forecast",
///     queryItems: [
///         URLQueryItem(name: "latitude", value: "52.52"),
///         URLQueryItem(name: "longitude", value: "13.405"),
///         URLQueryItem(name: "current_weather", value: "true")
///     ]
/// )
/// let request = endpoint.urlRequest
/// ```
///
/// # Advanced Example:
/// ```swift
/// // POST request with custom headers and body
/// let jsonData = try? JSONEncoder().encode(myPayload)
/// let endpoint = Endpoint(
///     scheme: "https",
///     host: "api.example.com",
///     path: "/v2/resource",
///     queryItems: [],
///     method: "POST",
///     headers: ["Content-Type": "application/json"],
///     body: jsonData
/// )
/// let request = endpoint.urlRequest
/// ```
struct Endpoint {
    /// The scheme of the URL (e.g., "https").
    let scheme: String
    /// The API host (e.g., "api.open-meteo.com").
    let host: String
    /// The path component (e.g., "/v1/forecast").
    let path: String
    /// Query parameters for the endpoint.
    let queryItems: [URLQueryItem]
    /// HTTP method (e.g., "GET", "POST").
    let method: String
    /// Optional HTTP headers.
    let headers: [String: String]?
    /// Optional body data (for POST/PUT requests).
    let body: Data?

    /// Composes a URLRequest from the endpoint.
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

    /// Convenience initializer for simple GET endpoints without headers or body.
    ///
    /// - Parameters:
    ///   - scheme: The URL scheme, defaults to "https".
    ///   - host: The host of the API.
    ///   - path: The endpoint path.
    ///   - queryItems: Query parameters.
    ///   - method: HTTP method, defaults to "GET".
    init(scheme: String = "https", host: String, path: String, queryItems: [URLQueryItem] = [], method: String = "GET") {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = nil
        self.body = nil
    }

    /// Full initializer for advanced use.
    ///
    /// - Parameters:
    ///   - scheme: The URL scheme, defaults to "https".
    ///   - host: The host of the API.
    ///   - path: The endpoint path.
    ///   - queryItems: Query parameters.
    ///   - method: HTTP method.
    ///   - headers: HTTP headers.
    ///   - body: HTTP body data.
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
