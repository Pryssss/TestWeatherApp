//
//  TestWeatherAppApp.swift
//  TestWeatherApp
//
//  Created by Markiyan Prysiazhniuk on 12.06.2025.
//

import SwiftUI

@main
struct TestWeatherAppApp: App {
    @StateObject private var coordinator = SimpleCoordinator()
    
    var body: some Scene {
        WindowGroup {
            MainNavigationView(coordinator: coordinator)
        }
    }
}
