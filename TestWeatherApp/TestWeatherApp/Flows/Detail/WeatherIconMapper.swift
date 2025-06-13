//
//  WeatherIconMapper.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation

struct WeatherIconMapper {
    static func iconName(for code: Int) -> String {
        switch code {
        case 0: return "sun.max"
        case 1: return "cloud.sun"
        case 2: return "cloud.sun"
        case 3: return "cloud"
        case 45, 48: return "cloud.fog"
        case 51, 53, 55: return "cloud.drizzle"
        case 56, 57: return "cloud.sleet"
        case 61, 63, 65: return "cloud.rain"
        case 66, 67: return "cloud.sleet"
        case 71, 73, 75, 77: return "cloud.snow"
        case 80, 81, 82: return "cloud.heavyrain"
        case 85, 86: return "cloud.snow"
        case 95: return "cloud.bolt"
        case 96, 99: return "cloud.bolt.rain"
        default: return "questionmark"
        }
    }
}
