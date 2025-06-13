//
//  DetailViewModel.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import Foundation
import SwiftUI
import Combine

struct DailyForecast: Identifiable, Equatable {
    let id = UUID()
    let date: String
    let iconName: String
    let temperature: String
}

class DetailViewModel<Forecast: Identifiable & Equatable>: ObservableObject {
    @Published private(set) var city: String
    @Published private(set) var currentTemperature: String = "--"
    @Published private(set) var dailyForecasts: [Forecast] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentWeatherCode: Int = 0

    private let weatherAPI: WeatherAPIProtocol
    private let lat: Double
    private let lon: Double
    private let forecastMapper: (WeatherResponse) -> [Forecast]

    init(
        city: String,
        lat: Double,
        lon: Double,
        weatherAPI: WeatherAPIProtocol = WeatherAPI(networking: DefaultNetworking()),
        forecastMapper: @escaping (WeatherResponse) -> [Forecast]
    ) {
        self.city = city
        self.lat = lat
        self.lon = lon
        self.weatherAPI = weatherAPI
        self.forecastMapper = forecastMapper
    }

    func load() {
        resetState()
        Task {
            do {
                let response = try await weatherAPI.fetchDailyWeather(latitude: lat, longitude: lon)
                await MainActor.run {
                    updateCurrentWeather(with: response)
                    updateDailyForecast(with: response)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }

    private func resetState() {
        errorMessage = nil
        isLoading = true
        dailyForecasts = []
        currentTemperature = "--"
    }

    private func updateCurrentWeather(with response: WeatherResponse) {
        guard let curr = response.current_weather else {
            currentTemperature = "--"
            currentWeatherCode = 0
            return
        }
        currentTemperature = String(format: "%.0f°C", curr.temperature)
        currentWeatherCode = curr.weathercode
    }

    private func updateDailyForecast(with response: WeatherResponse) {
        dailyForecasts = forecastMapper(response)
    }
}

// Provide concrete Forecast typealias for use in SwiftUI. For example:
typealias DefaultDetailViewModel = DetailViewModel<DailyForecast>
