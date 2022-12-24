//
//  TimerView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/17/22.
//

import SwiftUI


// TODO: Add progress meter
// TODO: Add Ability to choose alarm sound, etc.
struct TimerView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    @StateObject var timerModel: TimerModel = TimerModel()
    
    var body: some View {
        VStack(spacing: 8) {
            if timerModel.isTimerRunning {
                CountdownView(timerModel: timerModel)
                    .frame(minHeight: sizeClass == .compact ? 200: 250)
                    .padding()
            } else {
                CountdownPicker(duration: $timerModel.timeRemaining)
                    .frame(minHeight: sizeClass == .compact ? 200: 250)
                    .padding()
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
                                    .frame(width: 75, height: 75, alignment: .center)
                            )

                            Text("Cancel")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                
                    }.opacity(timerModel.isTimerRunning ? 1.0: 0.5)
                }
                .disabled(!timerModel.isTimerRunning)
                Spacer()
                Button {
                    withAnimation {
                        if !timerModel.isTimerRunning {
                            timerModel.start()
                        } else if timerModel.isTimerPaused {
                            timerModel.resume()
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
                                    .frame(width: 75, height: 75, alignment: .center)
                            )
                        Text(timerModel.isTimerRunning ? (timerModel.isTimerPaused ? "Resume" : "Pause"): "Start")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .opacity(0.8)
                            .blendMode(.lighten)
                    }
                }
                .disabled(timerModel.timeRemaining == 0 || timerModel.isTimerEnded)
                .opacity(timerModel.timeRemaining == 0 || timerModel.isTimerEnded ? 0.5: 1.0)
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
