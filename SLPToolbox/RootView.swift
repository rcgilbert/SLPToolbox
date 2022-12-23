//
//  RootView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    enum Screen: Int {
        case dataTracker
        case timer
        case ageCalculator
        case dateCalculator
        case notes
        case settings
    }
    
    @State var selectedScreen: Screen? = .dataTracker
    @AppStorage("selectedScreenIndex") var selectedScreenIndex: Int = Screen.dataTracker.rawValue
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedScreen) {
                Section {
                    NavigationLink(value: Screen.dataTracker) {
                        Label("Data Tracker", systemImage: "list.bullet.clipboard")
                    }
                    NavigationLink(value: Screen.timer) {
                        Label("Timer", systemImage: "timer.circle")
                    }
                    NavigationLink(value: Screen.ageCalculator) {
                        Label("Age Calculator", systemImage: "number.square")
                    }
                    NavigationLink(value: Screen.dateCalculator) {
                        Label("Date Calculator", systemImage: "calendar")
                    }
//                    NavigationLink(value: Screen.notes) {
//                        Label("Notes", systemImage: "note.text")
//                    }
                }
                Section {
                    NavigationLink(value: Screen.settings) {
                        Label("Settings", systemImage: "gearshape")
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SLP Toolbox")
        } detail: {
            switch selectedScreen {
            case .dataTracker, .none:
                DataTrackView()
                    .environment(\.managedObjectContext, viewContext)
            case .timer:
                TimerView()
                    .navigationTitle("Timer")
            case .ageCalculator:
                AgeCalculatorView()
                    .navigationTitle("Age Calculator")
            case .dateCalculator:
                DateCalculatorView()
                    .navigationTitle("Date Calculator")
            case .notes:
                Text("Notes Placeholder!")
                    .navigationTitle("Notes")
            case .settings:
                Text("Settings Placeholder!")
                    .navigationTitle("Settings")
           
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            selectedScreen = Screen(rawValue: selectedScreenIndex) ?? selectedScreen
        }
        .onChange(of: selectedScreen) { newValue in
            selectedScreenIndex = newValue?.rawValue ?? 0
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
