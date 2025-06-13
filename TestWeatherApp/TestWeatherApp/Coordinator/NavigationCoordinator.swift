//
//  NavigationCoordinator.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI
import Combine

/// Protocol defining a navigation coordinator using NavigationStack.
/// Coordinators manage navigation between screens/destinations in SwiftUI, providing stack-based operations.
protocol NavigationCoordinator: ObservableObject {
    /// The type representing each possible navigation destination.
    associatedtype Destination: Hashable

    /// The current navigation path as a stack of destinations.
    var path: [Destination] { get set }

    /// Pushes a new destination onto the navigation stack.
    func push(_ destination: Destination)

    /// Pops the top destination off the navigation stack.
    func pop()

    /// Pops all destinations to return to the root.
    func popToRoot()

    /// Resets navigation (optionally to a specific root).
    func reset()
}

/// A simple example coordinator implementation managing navigation using stack-based operations.
final class SimpleCoordinator: NavigationCoordinator {
    @Published var path: [Screen] = []

    let weatherViewModel = WeatherViewModel()

    /// Enum representing all screens in the app.
    enum Screen: Hashable {
        case main
        case detail(city: String)
    }

    /// Pushes a new screen onto the navigation stack.
    func push(_ destination: Screen) {
        path.append(destination)
    }

    /// Pops the top screen from the navigation stack.
    func pop() {
        _ = path.popLast()
    }

    /// Pops all screens to return to root.
    func popToRoot() {
        path.removeAll()
    }

    /// Resets navigation (removes all screens).
    func reset() {
        path.removeAll()
    }

    /// Starts the coordinator flow by setting the initial screen.
    func start() {
        // Now starting with MainScreen
        path = [.main]
        weatherViewModel.load()
    }
}
