//
//  AppState.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/29/22.
//

import Foundation
import Combine

enum AppScreen: String {
    case dataTracker
    case timer
    case ageCalculator
    case dateCalculator
    case settings
}

@MainActor class AppState: ObservableObject {
    @Published var selectedScreen: AppScreen? = .dataTracker
    @Published var timerModel: TimerModel = TimerModel()
    
    static let shared = AppState()
    
    func saveSelectedScreen() {
        UserDefaults.standard.set(selectedScreen?.rawValue, forKey: "AppState.SelectedScreen")
    }
    
    func loadSelectedScreen() {
        guard let selectedScreenName = UserDefaults.standard.object(forKey: "AppState.SelectedScreen") as? String,
              let storedSelectedScreen = AppScreen(rawValue: selectedScreenName) else {
            return
        }
        
        selectedScreen = storedSelectedScreen
    }
}
