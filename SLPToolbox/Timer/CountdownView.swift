//
//  CountdownView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/21/22.
//

import SwiftUI

struct CountdownView: View {
    private let timerFormatter: DateComponentsFormatter = {
        $0.unitsStyle = .positional
        $0.allowedUnits = [.hour, .minute, .second]
        $0.zeroFormattingBehavior = .pad
        return $0
    }(DateComponentsFormatter())
    
    private let secondaryFormatter: DateComponentsFormatter = {
        $0.unitsStyle = .full
        $0.allowedUnits = [.hour, .minute, .second]
        $0.zeroFormattingBehavior = .dropLeading
        return $0
    }(DateComponentsFormatter())
    
    private let dateFormatter: DateFormatter = {
        $0.dateStyle = .none
        $0.timeStyle = .short
        return $0
    }(DateFormatter())
    
    @ObservedObject var timerModel: TimerModel

    private func countdownTexts(for start: Date, end: Date) -> some View {
        Group {
            Text(Calendar.current
                .dateComponents([.hour,.minute,.second],
                                from: start,
                                to: end),
                 formatter: timerFormatter)
            .padding([.leading, .trailing, .bottom], 16)
            .font(.system(size: 100))
            .fontDesign(.monospaced)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            
            if start == end {
                Text("Timer Finished!")
                    .font(.headline)
            } else {
                Text(Calendar.current
                    .dateComponents([.hour,.minute,.second],
                                    from: start,
                                    to: end),
                     formatter: secondaryFormatter)
                    .font(.headline)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if timerModel.isTimerPaused {
                countdownTexts(for: .now, end: Date.now.addingTimeInterval(timerModel.timeRemaining))
            }
            else if !timerModel.isTimerEnded {
                TimelineView(.periodic(from: .now, by: 1)) { timeline in
                    if timeline.date < timerModel.endDate  {
                        countdownTexts(for: timeline.date, end: timerModel.endDate)
                    }
                }
            } else {
                withAnimation {
                    countdownTexts(for: timerModel.endDate, end: timerModel.endDate)
                        .foregroundColor(.secondary)
                }
            }
            Label {
                Text(timerModel.endDate, formatter: dateFormatter)
            } icon: {
                Image(systemName: "bell.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .opacity(timerModel.isTimerPaused ? 0.5: 1.0)
            .padding(.top, 1)
        }
    }
}
