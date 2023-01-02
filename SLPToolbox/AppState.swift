//
//  AppState.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/29/22.
//

import Foundation
import Combine
import SwiftUI

enum AppScreen: String {
    case dataTracker
    case timer
    case ageCalculator
    case dateCalculator
    case settings
}

@MainActor class AppState: ObservableObject {
    @AppStorage("AppState.SelectedScreen") var selectedScreen: AppScreen?
    @Published var timerModel: TimerModel = TimerModel()
    
    static let shared = AppState()
}
