//
//  WeatherCache.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation

final class WeatherCache {
    static let shared = WeatherCache()
    private init() {}

    private var cityWeathers: [CityWeather]? = nil

    func getCityWeathers() -> [CityWeather]? {
        cityWeathers
    }

    func setCityWeathers(_ weathers: [CityWeather]) {
        cityWeathers = weathers
    }
}
