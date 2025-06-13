//
//  City.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 14.06.2025.
//

import Foundation

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
