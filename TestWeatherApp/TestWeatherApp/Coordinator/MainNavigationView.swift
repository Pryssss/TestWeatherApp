//
//  MainNavigationView.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI

struct MainNavigationView: View {
    @StateObject var coordinator = SimpleCoordinator()

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
        case .detail(let cityName):
            if let city = City.from(cityName) {
                DetailView(viewModel: DefaultDetailViewModel(
                    city: city.rawValue,
                    lat: city.coordinates.lat,
                    lon: city.coordinates.lon,
                    forecastMapper: { (response: WeatherResponse) in
                        response.days.map { day in
                            DailyForecast(
                                date: day.date,
                                iconName: WeatherIconMapper.iconName(for: day.code),
                                temperature: String(format: "%.0f°C / %.0f°C", day.min, day.max)
                            )
                        }
                    }
                ))
            } else {
                Text("City not found")
            }


        }
    }
}
