//
//  NavigationCoordinator.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI
import Combine

protocol NavigationCoordinator: ObservableObject {
    associatedtype Destination: Hashable
    var path: [Destination] { get set }
    func push(_ destination: Destination)
    func pop()
    func popToRoot()
    func reset()
}

final class SimpleCoordinator: NavigationCoordinator {
    @Published var path: [Screen] = []

    let weatherViewModel = WeatherViewModel()

    enum Screen: Hashable {
        case main
        case detail(city: String)
    }

    func push(_ destination: Screen) {
        path.append(destination)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func reset() {
        path.removeAll()
    }

    func start() {
        path = [.main]
        weatherViewModel.load()
    }
}
