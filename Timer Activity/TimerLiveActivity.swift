//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Ryan Gilbert on 12/26/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var endDate: Date
        var timeRemaining: TimeInterval
        var isTimerPaused: Bool
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                HStack {
                    Button {
                        var newState = context.state
                        newState.isTimerPaused.toggle()
                        if context.state.isTimerPaused {
                            newState.timeRemaining = newState.endDate.timeIntervalSinceNow
                        } else {
                            newState.endDate = .init(timeIntervalSinceNow: newState.timeRemaining)
                        }
                    } label: {
                        Image(systemName: context.state.isTimerPaused ? "play.circle.fill": "pause.circle.fill")
                            .resizable()
                            .symbolRenderingMode(.hierarchical)
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(.orange)
                            .frame(minHeight: 50)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(minHeight: 50)
                    }
                }
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    Text("Timer")
                        .font(.headline)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.orange)
                        
                    Text(context.state.endDate, style: .timer)
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                }
            }
            .padding(16)
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct TimerLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerAttributes(name: "Me")
    static let contentState = TimerAttributes.ContentState(endDate: .init(timeIntervalSinceNow: 3600),
                                                           timeRemaining: 3700,
                                                           isTimerPaused: false)
    
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
