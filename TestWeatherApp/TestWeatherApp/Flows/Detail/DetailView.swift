//
//  DetailView.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel<DailyForecast>

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.45), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.city)
                                .font(.largeTitle.bold())
                        }
                        Spacer()
                        Text(viewModel.currentTemperature)
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundColor(.blue)
                    }

                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue.opacity(0.8), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                                .frame(width: 100, height: 100)
                                .shadow(radius: 10)
                            WeatherIconView(code: viewModel.currentWeatherCode)
                                .foregroundColor(.white)
                                .font(.system(size: 64))
                        }
                        Spacer()
                    }

                    Text("Forecast")
                        .font(.title2.bold())
                        .padding(.top, 12)

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    } else {
                        forecastList
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.75))
                        .shadow(radius: 20)
                )
                .padding(.horizontal)
            }
        }
        .task { viewModel.load() }
    }
    
    private var forecastList: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.dailyForecasts as [DailyForecast], id: \.id) { forecast in
                HStack {
                    Image(systemName: forecast.iconName)
                        .foregroundColor(.blue)
                        .font(.title2)
                        .frame(width: 24, height: 24)
                    DayLabelView(rawDate: forecast.date)
                        .font(.title3).bold()
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.15), radius: 2, x: 0, y: 1)
                    Spacer()
                    Text(forecast.temperature)
                        .font(.title3).bold()
                        .foregroundColor(.blue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: .gray.opacity(0.15), radius: 5, x: 0, y: 2)
                )
            }
        }
        .padding(.top, 4)
    }
}

struct WeatherIconView: View {
    let code: Int
    var body: some View {
        let symbol = WeatherIconMapper.iconName(for: code)
        return Image(systemName: symbol)
    }
}

struct DayLabelView: View {
    let rawDate: String
    var body: some View {
        Text(Self.displayDay(from: rawDate))
    }
    private static func displayDay(from rawDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: rawDate) else { return rawDate }
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: date)
        }
    }
}

