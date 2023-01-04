//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Ryan Gilbert on 12/26/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("Timer")
                        .font(.headline)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                        .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
                    Text(timerInterval: context.state.timerDateRange,
                         countsDown: true)
                            .font(.largeTitle)
                            .monospacedDigit()
                            .foregroundColor(.white)
                            .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.5)
                }
                Spacer()
                HStack {
                    Link(destination: URL(string: "slptoolbox://timer?action=cancel")!) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 30)
                    }
                }
            }
            .padding(16)
            .activitySystemActionForegroundColor(Color.primary)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer.circle")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.orangeish)
                        .frame(width: 30)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Link(destination: URL(string: "slptoolbox://timer?action=cancel")!) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .frame(height: 35)
                                .foregroundColor(.orangeish)
                            Text("Cancel")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }.padding([.leading, .trailing], 8)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(timerInterval: context.state.timerDateRange,
                         countsDown: true)
                    .font(.system(size: 50))
                    .monospacedDigit()
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                }
            } compactLeading: {
                Image(systemName: "timer.circle")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.orangeish)
            } compactTrailing: {
                Text(timerInterval: context.state.timerDateRange,
                     countsDown: true)
                .monospacedDigit()
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: 50)
            } minimal: {
                Text(timerInterval: context.state.timerDateRange,
                     countsDown: true)
                .monospacedDigit()
                .foregroundColor(.white)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
            }
            .widgetURL(URL(string: "slptoolbox://timer"))
        }
    }
}

struct TimerLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerAttributes(name: "Me")
    static let contentState = TimerAttributes.ContentState(endDate: .init(timeIntervalSinceNow: 3600))
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
