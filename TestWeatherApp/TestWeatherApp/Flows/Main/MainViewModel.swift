//
//  MainViewModel.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 13.06.2025.
//

import Foundation
import Combine
import SwiftUI

struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let temperature: String
    let description: String
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        lhs.id == rhs.id && lhs.city == rhs.city && lhs.temperature == rhs.temperature && lhs.description == rhs.description
    }
}

class WeatherViewModel: ObservableObject {
    @Published var cityWeathers: [CityWeather] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let weatherAPI = WeatherAPI(networking: DefaultNetworking())
    private static var cachedCityWeathers: [CityWeather]? = nil

    private var cities = [
        (name: "London", lat: 51.5074, lon: -0.1278),
        (name: "Paris", lat: 48.8566, lon: 2.3522),
        (name: "Berlin", lat: 52.52, lon: 13.4050),
        (name: "Rome", lat: 41.9028, lon: 12.4964),
        (name: "Madrid", lat: 40.4168, lon: -3.7038),
        (name: "Vienna", lat: 48.2082, lon: 16.3738),
        (name: "Amsterdam", lat: 52.3676, lon: 4.9041),
        (name: "Prague", lat: 50.0755, lon: 14.4378),
        (name: "Budapest", lat: 47.4979, lon: 19.0402),
        (name: "Lisbon", lat: 38.7223, lon: -9.1393),
        (name: "Athens", lat: 37.9838, lon: 23.7275),
        (name: "Barcelona", lat: 41.38, lon: 2.17),
        (name: "Warsaw", lat: 52.23, lon: 21.01),
        (name: "Kyiv", lat: 50.45, lon: 30.52)
    ]

    
    init() {
        load()
    }

    func load(forceReload: Bool = false) {
        if !forceReload, let cached = Self.cachedCityWeathers, !cached.isEmpty {
            self.cityWeathers = cached
            return
        }
        errorMessage = nil
        isLoading = true
        cityWeathers = []
        Task {
            do {
                var results: [CityWeather] = []
                for city in City.allCases { 
                    let weather = try await weatherAPI.fetchCurrentWeather(latitude: city.coordinates.lat, longitude: city.coordinates.lon)
                    if let current = weather.current_weather {
                        let cityWeather = CityWeather(
                            city: city.rawValue,
                            temperature: "\(Int(current.temperature))°C",
                            description: "Code: \(current.weathercode)"
                        )
                        results.append(cityWeather)
                    } else {
                        let cityWeather = CityWeather(
                            city: city.rawValue,
                            temperature: "--",
                            description: "No data"
                        )
                        results.append(cityWeather)
                    }

                }
                await MainActor.run {
                    withAnimation {
                        self.cityWeathers = results
                        self.isLoading = false
                        Self.cachedCityWeathers = results
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

