//
//  TimerView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/17/22.
//

import SwiftUI


// TODO: Fix Layout for Horizontal Layout
// TODO: Add progress meter
// TODO: Add Ability to choose alarm sound, etc.
struct TimerView: View {
    @State var countdownDuration: TimeInterval = 0
    @StateObject var timerModel: TimerModel = TimerModel()
    
    var body: some View {
        VStack(spacing: 100) {
            Spacer()
            VStack {
                if timerModel.isTimerRunning {
                    CountdownView(timerModel: timerModel)
                        .frame(minHeight: 200)
                        .padding()
                } else {
                    CountdownPicker(duration: $timerModel.timeRemaining)
                        .frame(minHeight: 200)
                        .padding()
                }
            }
            HStack {
                Button {
                    withAnimation {
                        timerModel.stop()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.gray)
                            .overlay(
                                Circle()
                                    .stroke(Color(uiColor: UIColor.systemBackground).opacity(0.8), lineWidth: 2)
                                    .frame(width: 70, height: 70, alignment: .center)
                            )
                            Text("Cancel")
                                .foregroundColor(.white)
                                .opacity(timerModel.isTimerRunning ? 1.0: 0.5)
                    }
                }
                .disabled(!timerModel.isTimerRunning)
                Spacer()
                Button {
                    withAnimation {
                        if !timerModel.isTimerRunning || timerModel.isTimerPaused {
                            timerModel.start()
                        } else {
                            timerModel.pause()
                        }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(timerModel.isTimerRunning && !timerModel.isTimerPaused ? Color.orange: Color.green)
                            .overlay(
                                Circle()
                                    .stroke(Color(uiColor: UIColor.systemBackground).opacity(0.8), lineWidth: 2)
                                    .frame(width: 70, height: 70, alignment: .center)
                            )
                        Text(timerModel.isTimerRunning ? (timerModel.isTimerPaused ? "Resume" : "Pause"): "Start")
                            .foregroundStyle(.thickMaterial)
                    }
                }
                .disabled(timerModel.timeRemaining == 0 || timerModel.isTimerEnded)
            }.padding([.leading, .trailing], 40)
            Spacer()
        }
        .onAppear {
            timerModel.requestNotificationPermissions()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environment(\.locale, Locale(identifier: "ee_TG"))
    }
}
