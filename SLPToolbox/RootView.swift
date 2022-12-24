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
            ScrollView {
                LazyVGrid(columns: [GridItem(spacing: 16), GridItem()]) {
                    Button {
                        selectedScreen = .dataTracker
                    } label: {
                        NavCellView(title: "Data Tracker",
                                    systemImageName: "list.bullet.clipboard",
                                    color: .orangeish)
                    }
                    Button {
                        selectedScreen = .timer
                    } label: {
                        NavCellView(title: "Timer",
                                    systemImageName: "timer.circle",
                                    color: .brightPink)
                    }
                    Button {
                        selectedScreen = .ageCalculator
                    } label: {
                        NavCellView(title: "Age Calculator",
                                    systemImageName: "number.square",
                                    color: .purpleish)
                    }
                    Button {
                        selectedScreen = .dateCalculator
                    } label: {
                        NavCellView(title: "Date Calulator",
                                    systemImageName: "calendar",
                                    color: .greenish)
                    }
                    Button {
                        selectedScreen = .settings
                    } label: {
                        NavCellView(title: "Settings",
                                    systemImageName: "gearshape",
                                    color: .grayish)
                    }
                }.padding()
            }
            .navigationTitle("SLP Toolbox")
            
            List(selection: $selectedScreen) { }
                .frame(height: 0)
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
                SettingsView()
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
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding([.leading, .trailing], 8)
            }
        }
    }
}
