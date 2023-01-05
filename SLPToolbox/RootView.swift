//
//  RootView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var appState: AppState
   
    var body: some View {
        NavigationSplitView {
            List(selection: $appState.selectedScreen) {
                Section {
                    NavCellView(title: "Data Tracker",
                                systemImageName: "list.bullet.clipboard",
                                color: .orangeish,
                                screen: .dataTracker)
                    NavCellView(title: "Timer",
                                systemImageName: "timer.circle",
                                color: .brightPink,
                                screen: .timer)
                    NavCellView(title: "Age Calculator",
                                systemImageName: "number.square",
                                color: .purpleish,
                                screen: .ageCalculator)
                    NavCellView(title: "Date Calulator",
                                systemImageName: "calendar",
                                color: .greenish,
                                screen: .dateCalculator)
                }
                Section {
                    NavCellView(title: "Settings",
                                systemImageName: "gearshape",
                                color: .grayish,
                                screen: .settings)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SLP Toolbox")
        } detail: {
            switch appState.selectedScreen {
            case .dataTracker, .none:
                DataTrackView()
                    .environment(\.managedObjectContext, viewContext)
            case .timer:
                TimerView(timerModel: appState.timerModel)
                    .navigationTitle("Timer")
            case .ageCalculator:
                AgeCalculatorView()
                    .navigationTitle("Age Calculator")
            case .dateCalculator:
                DateCalculatorView()
                    .navigationTitle("Date Calculator")
            case .settings:
                SettingsView()
                    .navigationTitle("Settings")
                
            }
        }
        .onOpenURL { url in
            if url.pathComponents.first == "timer" {
                appState.selectedScreen = .timer
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppState.shared)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct NavCellView: View {
    @State var title: String
    @State var systemImageName: String
    @State var color: Color = .orangeish
    @State var screen: AppScreen
    
    @State var isTapped: Bool = false
    
    var body: some View {
        NavigationLink(value: screen) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(color)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 40)
                    Image(systemName: systemImageName)
                        .font(.body)
                        .imageScale(.large)
                        .foregroundStyle(.white)
                }.shadow(color: .gray.opacity(0.5), radius: 1, x: 0, y: 1)
               
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
            }.padding(8)
        }
    }
}
