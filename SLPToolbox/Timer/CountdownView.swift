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
    
    private func endTimeText(for endDate: Date) -> some View {
        Label {
            Text(endDate, formatter: dateFormatter)
        } icon: {
            Image(systemName: "bell.fill")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
        .padding(.top, 1)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            switch timerModel.timerState {
            case .paused(let timeRemaining):
                Group {
                    countdownTexts(for: .now, end: Date.now.addingTimeInterval(timeRemaining))
                    endTimeText(for: .now.addingTimeInterval(timeRemaining))
                        .opacity(0.5)
                }
            case .running(let endDate):
                Group {
                    TimelineView(.periodic(from: .now, by: 1)) { timeline in
                        if timeline.date < endDate  {
                            countdownTexts(for: timeline.date, end: endDate)
                        }
                    }
                    endTimeText(for: endDate)
                }
            case .ended(let endDate):
                Group {
                    countdownTexts(for: endDate, end: endDate)
                        .foregroundColor(.secondary)
                    endTimeText(for: endDate)
                }
            case .inactive:
                EmptyView()
            }
        }
    }
}
