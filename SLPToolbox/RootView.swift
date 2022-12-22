//
//  RootView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    enum Screen {
        case dataTracker
        case timer
        case ageCalculator
        case dateCalculator
        case notes
        case settings
    }
    
    @State var selectedScreen: Screen? = .dataTracker
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedScreen) {
                Section {
                    NavigationLink(value: Screen.dataTracker) {
                        Label("Data Tracker", systemImage: "list.bullet.clipboard")
                            .symbolRenderingMode(.multicolor)
                    }
                    NavigationLink(value: Screen.timer) {
                        Label("Timer", systemImage: "timer.circle")
                            .symbolRenderingMode(.multicolor)
                    }
                    NavigationLink(value: Screen.ageCalculator) {
                        Label("Age Calculator", systemImage: "number.circle")
                            .symbolRenderingMode(.multicolor)
                    }
                    NavigationLink(value: Screen.dateCalculator) {
                        Label("Date Calculator", systemImage: "calendar.circle")
                            .symbolRenderingMode(.multicolor)
                    }
                    NavigationLink(value: Screen.notes) {
                        Label("Notes", systemImage: "note.text")
                            .symbolRenderingMode(.multicolor)
                    }
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
                Text("Age Calculator Placeholder!")
                    .navigationTitle("Age Calculator")
            case .dateCalculator:
                Text("Date Calculator Placeholder!")
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
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
