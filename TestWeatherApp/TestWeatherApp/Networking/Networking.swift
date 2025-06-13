//
//  Networking.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import Foundation

/// Protocol describing a generic, async/await-based networking engine.
/// Designed for easy mocking and flexible API calls.
protocol Networking {
    /// Sends a request to the given endpoint and decodes the response as the provided type.
    /// - Parameter endpoint: The endpoint for the request (see `Endpoint`).
    /// - Returns: The decoded response.
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

/// Default implementation of Networking using URLSession.
final class DefaultNetworking: Networking {
    /// Sends a request to the endpoint and decodes the response using JSONDecoder.
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: endpoint.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
