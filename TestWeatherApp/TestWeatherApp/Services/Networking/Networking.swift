//
//  Networking.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import Foundation

protocol Networking {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class DefaultNetworking: Networking {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: endpoint.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

