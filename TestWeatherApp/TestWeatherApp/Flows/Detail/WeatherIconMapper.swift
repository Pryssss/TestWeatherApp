//
//  WeatherIconMapper.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation

/// Encapsulates weather code to SF Symbol icon mapping.
struct WeatherIconMapper {
    /// Maps weather codes to SF Symbol icon names for weather conditions.
    static func iconName(for code: Int) -> String {
        switch code {
        case 0: // Clear sky
            return "sun.max"
        case 1: // Mainly clear
            return "cloud.sun"
        case 2: // Partly cloudy
            return "cloud.sun"
        case 3: // Overcast
            return "cloud"
        case 45, 48: // Fog
            return "cloud.fog"
        case 51, 53, 55: // Drizzle
            return "cloud.drizzle"
        case 56, 57: // Freezing drizzle
            return "cloud.sleet"
        case 61, 63, 65: // Rain
            return "cloud.rain"
        case 66, 67: // Freezing rain
            return "cloud.sleet"
        case 71, 73, 75, 77: // Snow
            return "cloud.snow"
        case 80, 81, 82: // Showers
            return "cloud.heavyrain"
        case 85, 86: // Snow showers
            return "cloud.snow"
        case 95: // Thunderstorm
            return "cloud.bolt"
        case 96, 99: // Thunderstorm with hail
            return "cloud.bolt.rain"
        default:
            return "questionmark"
        }
    }
}
