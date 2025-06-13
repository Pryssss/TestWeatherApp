//
//  MainScreen.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//
import SwiftUI

struct CityWeatherRow: View {
    let cityWeather: CityWeather
    let onSelect: (CityWeather) -> Void

    var body: some View {
        HStack {
            Text(cityWeather.city)
                .font(.title3.bold())
                .foregroundColor(.black)
                .accessibilityLabel(cityWeather.city)
            Spacer()
            Text(cityWeather.temperature)
                .font(.title3.bold())
                .foregroundColor(.blue)
                .accessibilityLabel("\(cityWeather.temperature)")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(1.0))
                .shadow(color: .gray.opacity(0.15), radius: 5, x: 0, y: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect(cityWeather)
        }
        .transition(.scale.combined(with: .opacity))
    }
}

struct MainScreen: View {
    @ObservedObject var viewModel: WeatherViewModel
    var onSelectCity: (CityWeather) -> Void = { _ in }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.45), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer(minLength: 20)
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Fetching weather...")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.cityWeathers, id: \.id) { cityWeather in
                                    CityWeatherRow(cityWeather: cityWeather) { selectedCityWeather in
                                        onSelectCity(selectedCityWeather)
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .refreshable {
                            viewModel.load(forceReload: true)
                        }
                    }
                    Button("Reload") {
                        viewModel.load(forceReload: true)
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 12)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.75))
                        .shadow(radius: 20)
                )
                .padding(.horizontal)
                Spacer(minLength: 20)
            }
        }
    }
}

#Preview {
    MainScreen(viewModel: WeatherViewModel(), onSelectCity: { _ in })
}
