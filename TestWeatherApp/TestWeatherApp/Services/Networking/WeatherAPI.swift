//
//  WeatherAPI.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import Foundation

struct WeatherResponse: Decodable {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let weathercode: Int
        let time: String
    }
    struct Daily: Identifiable {
        let id: String
        let date: String
        let min: Double
        let max: Double
        let code: Int
    }
    let latitude: Double
    let longitude: Double
    let current_weather: CurrentWeather?
    let daily: DailyValues?

    struct DailyValues: Decodable {
        let time: [String]
        let temperature_2m_min: [Double]
        let temperature_2m_max: [Double]
        let weathercode: [Int]
    }
    var days: [Daily] {
        guard let daily = daily else { return [] }
        return zip(zip(zip(daily.time, daily.temperature_2m_min), daily.temperature_2m_max), daily.weathercode)
            .map { zipped, code in
                let ((date, min), max) = zipped
                return Daily(id: date, date: date, min: min, max: max, code: code)
            }
    }
}

protocol WeatherAPIProtocol {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
    func fetchDailyWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
}

final class WeatherAPI<Network: Networking>: WeatherAPIProtocol {
    private let networking: Network
    private let endpointBuilder: WeatherEndpointBuilder.Type

    init(networking: Network, endpointBuilder: WeatherEndpointBuilder.Type = WeatherEndpointBuilder.self) {
        self.networking = networking
        self.endpointBuilder = endpointBuilder
    }

    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let endpoint = endpointBuilder.weather(latitude: latitude, longitude: longitude, daily: false)
        return try await networking.request(endpoint)
    }

    func fetchDailyWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let endpoint = endpointBuilder.weather(latitude: latitude, longitude: longitude, daily: true)
        return try await networking.request(endpoint)
    }
}

struct WeatherEndpointBuilder {
    static func weather(latitude: Double, longitude: Double, daily: Bool) -> Endpoint {
        var queryItems: [URLQueryItem] = [
            .init(name: "latitude", value: "\(latitude)"),
            .init(name: "longitude", value: "\(longitude)"),
            .init(name: "current_weather", value: "true")
        ]
        if daily {
            queryItems.append(.init(name: "daily", value: "temperature_2m_max,temperature_2m_min,weathercode"))
        }
        return Endpoint(
            host: "api.open-meteo.com",
            path: "/v1/forecast",
            queryItems: queryItems,
            method: "GET"
        )
    }
}
