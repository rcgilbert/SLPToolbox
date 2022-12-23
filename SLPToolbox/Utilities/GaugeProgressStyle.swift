//
//  GaugeProgressStyle.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/23/22.
//

import SwiftUI

struct GaugeProgressStyle<S: ShapeStyle>: ProgressViewStyle {
    var stroke: S
    var strokeWidth = 25.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .stroke(stroke, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .opacity(0.3)
                .blendMode(.luminosity)
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(stroke, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: fractionCompleted)
            
            configuration.label
        }
    }
}
