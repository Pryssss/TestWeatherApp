//
//  MainViewModel.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 13.06.2025.
//

import Foundation
import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var cityWeathers: [CityWeather] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let weatherAPI = WeatherAPI(networking: DefaultNetworking())

    init() {
        load()
    }

    func load(forceReload: Bool = false) {
        if !forceReload, let cached = WeatherCache.shared.getCityWeathers(), !cached.isEmpty {
            self.cityWeathers = cached
            return
        }
        errorMessage = nil
        isLoading = true
        cityWeathers = []
        Task {
            do {
                var results: [CityWeather] = []
                try await withThrowingTaskGroup(of: CityWeather.self) { group in
                    for city in City.allCases {
                        group.addTask {
                            do {
                                let weather = try await self.weatherAPI.fetchCurrentWeather(latitude: city.coordinates.lat, longitude: city.coordinates.lon)
                                if let current = weather.current_weather {
                                    return CityWeather(
                                        city: city.rawValue,
                                        temperature: "\(Int(current.temperature))°C",
                                        description: "Code: \(current.weathercode)"
                                    )
                                } else {
                                    return CityWeather(
                                        city: city.rawValue,
                                        temperature: "--",
                                        description: "No data"
                                    )
                                }
                            } catch {
                                return CityWeather(
                                    city: city.rawValue,
                                    temperature: "--",
                                    description: "Error: \(error.localizedDescription)"
                                )
                            }
                        }
                    }
                    for try await cityWeather in group {
                        results.append(cityWeather)
                    }
                }
                results.sort { $0.city < $1.city }
                await MainActor.run {
                    withAnimation {
                        self.cityWeathers = results
                        self.isLoading = false
                        WeatherCache.shared.setCityWeathers(results)
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
