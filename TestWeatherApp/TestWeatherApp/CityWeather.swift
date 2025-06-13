//
//  CityWeather.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation

struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let temperature: String
    let description: String

    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        lhs.id == rhs.id
    }
}
