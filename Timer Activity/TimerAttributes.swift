//
//  TimerAttributes.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 1/2/23.
//

import Foundation
import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var endDate: Date
        var timerDateRange: ClosedRange<Date> {
            Date.now...endDate
        }
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
