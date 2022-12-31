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
            ScrollView {
                LazyVGrid(columns: [GridItem(spacing: 16), GridItem()]) {
                    Button {
                        appState.selectedScreen = .dataTracker
                    } label: {
                        NavCellView(title: "Data Tracker",
                                    systemImageName: "list.bullet.clipboard",
                                    color: .orangeish)
                    }
                    Button {
                        appState.selectedScreen = .timer
                    } label: {
                        NavCellView(title: "Timer",
                                    systemImageName: "timer.circle",
                                    color: .brightPink)
                    }
                    Button {
                        appState.selectedScreen = .ageCalculator
                    } label: {
                        NavCellView(title: "Age Calculator",
                                    systemImageName: "number.square",
                                    color: .purpleish)
                    }
                    Button {
                        appState.selectedScreen = .dateCalculator
                    } label: {
                        NavCellView(title: "Date Calulator",
                                    systemImageName: "calendar",
                                    color: .greenish)
                    }
                    Button {
                        appState.selectedScreen = .settings
                    } label: {
                        NavCellView(title: "Settings",
                                    systemImageName: "gearshape",
                                    color: .grayish)
                    }
                }.padding()
            }
            .navigationTitle("SLP Toolbox")
            
            List(selection: $appState.selectedScreen) { }
                .frame(height: 0)
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
            print(url)
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
    }
}

struct NavCellView: View {
    @State var title: String
    @State var systemImageName: String
    @State var color: Color = .orangeish
   
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(color)
                .aspectRatio(1.2, contentMode: .fit)
                .shadow(radius: 3, x: 3, y: 3)
            VStack(spacing: 16) {
                Image(systemName: systemImageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 32)
                    .foregroundColor(.white)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding([.leading, .trailing], 8)
            }
        }
    }
}
