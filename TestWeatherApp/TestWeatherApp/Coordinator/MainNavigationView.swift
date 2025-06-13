//
//  MainNavigationView.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI

enum City: String, CaseIterable {
    case london = "London"
    case paris = "Paris"
    case berlin = "Berlin"
    case rome = "Rome"
    case madrid = "Madrid"
    case vienna = "Vienna"
    case amsterdam = "Amsterdam"
    case prague = "Prague"
    case budapest = "Budapest"
    case lisbon = "Lisbon"
    case athens = "Athens"
    case barcelona = "Barcelona"
    case warsaw = "Warsaw"
    case kyiv = "Kyiv"

    var coordinates: (lat: Double, lon: Double) {
        switch self {
        case .london: return (51.5074, -0.1278)
        case .paris: return (48.8566, 2.3522)
        case .berlin: return (52.52, 13.4050)
        case .rome: return (41.9028, 12.4964)
        case .madrid: return (40.4168, -3.7038)
        case .vienna: return (48.2082, 16.3738)
        case .amsterdam: return (52.3676, 4.9041)
        case .prague: return (50.0755, 14.4378)
        case .budapest: return (47.4979, 19.0402)
        case .lisbon: return (38.7223, -9.1393)
        case .athens: return (37.9838, 23.7275)
        case .barcelona: return (41.38, 2.17)
        case .warsaw: return (52.23, 21.01)
        case .kyiv: return (50.45, 30.52)
        }
    }

    static func from(_ cityName: String) -> City? {
        City.allCases.first { $0.rawValue.caseInsensitiveCompare(cityName) == .orderedSame }
    }
}

struct MainNavigationView: View {
    @ObservedObject var coordinator: SimpleCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content(for: coordinator.path.last ?? .main)
                .navigationDestination(for: SimpleCoordinator.Screen.self) { screen in
                    content(for: screen)
                }
        }
        .onAppear {
            coordinator.start()
            coordinator.path = []
        }
    }
    
    @ViewBuilder
    private func content(for screen: SimpleCoordinator.Screen) -> some View {
        switch screen {
        case .main:
            let vm = WeatherViewModel()
            MainScreen(viewModel: vm, onSelectCity: { cityWeather in
                withAnimation(.easeInOut(duration: 0.4)) {
                    coordinator.push(.detail(city: cityWeather.city))
                }
            })
            .onAppear {
                vm.load()
            }
        case .detail(let city):
      
            let coords = coordsForCity(city)
            DetailView(viewModel: DetailViewModel(city: city, lat: coords.lat, lon: coords.lon, forecastMapper: { response in
                response.days.map { day in
                    DailyForecast(
                        date: day.date,
                        iconName: WeatherIconMapper.iconName(for: day.code),
                        temperature: String(format: "%.0f°C / %.0f°C", day.min, day.max)
                    )
                }
            }))
        }
    }
    
    private func coordsForCity(_ city: String) -> (lat: Double, lon: Double) {
        return City.from(city)?.coordinates ?? (0, 0)
    }
}
