//
//  TimerView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/17/22.
//

import SwiftUI


struct CircleButtonView: View {
    @State var color: Color
    @State var label: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(color)
                .overlay(
                    Circle()
                        .stroke(Color(uiColor: UIColor.systemBackground).opacity(0.8), lineWidth: 2)
                        .frame(width: 75, height: 75, alignment: .center)
                )
            
            Text(label)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
    }
}

// TODO: Add progress meter
// TODO: Add Ability to choose alarm sound, etc.
struct TimerView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    @ObservedObject var timerModel: TimerModel
    @SceneStorage("TimerView.Duration") var duration: TimeInterval = 0
    
    var cancelButton: some View {
        Button {
            withAnimation {
                timerModel.cancel()
            }
        } label: {
            CircleButtonView(color: .gray, label: "Cancel")
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Top
            switch timerModel.timerState {
            case .inactive:
                CountdownPicker(duration: $duration)
                    .frame(minHeight: sizeClass == .compact ? 200: 250)
                    .padding()
                
            case .running, .paused, .ended:
                CountdownView(timerModel: timerModel)
                    .frame(minHeight: sizeClass == .compact ? 200: 250)
                    .padding()
            }
            
            // Buttons
            HStack {
                switch timerModel.timerState {
                case .inactive:
                    cancelButton
                        .opacity(0.5)
                        .disabled(true)
                    Spacer()
                    Button {
                        timerModel.start(withDuration: duration)
                    } label: {
                        CircleButtonView(color: .green, label: "Start")
                    }
                    
                case .running:
                    cancelButton
                    Spacer()
                    Button {
                        timerModel.pause()
                    } label: {
                        CircleButtonView(color: .orange, label: "Pause")
                    }
                case .paused:
                    cancelButton
                    Spacer()
                    Button {
                        timerModel.resume()
                    } label: {
                        CircleButtonView(color: .orange, label: "Resume")
                    }
                case .ended:
                    cancelButton
                    Spacer()
                    Button {
                        // No op
                    } label: {
                        CircleButtonView(color: .orange, label: "Pause")
                    }
                    .disabled(true)
                    .opacity(0.5)
                }
            }.padding([.leading, .trailing], 40)
            Spacer()
        }
        .onAppear {
            timerModel.requestNotificationPermissions()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    @StateObject static var timerModel = TimerModel()
    
    static var previews: some View {
        TimerView(timerModel: timerModel)
            .environment(\.locale, Locale(identifier: "ee_TG"))
    }
}
