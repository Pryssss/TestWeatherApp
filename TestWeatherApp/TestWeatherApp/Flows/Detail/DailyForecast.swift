//
//  DailyForecast.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation


struct DailyForecast: Identifiable, Equatable, Sendable {
    let id = UUID()
    let date: String
    let iconName: String
    let temperature: String
}
