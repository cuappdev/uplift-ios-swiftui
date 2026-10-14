//
//  RangeSlider.swift
//  Uplift
//
//  Created by Sandy Yang on 10/7/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct RangeSlider: View {

    // MARK: - Properties

    @Binding var lower: Double
    @Binding var upper: Double

    let bounds: ClosedRange<Double>
    var step: Double
    var minGap: Double

    @State private var lowerDragStart: Double?
    @State private var upperDragStart: Double?

    private let thumbSize: CGFloat = 24
    private let trackHeight: CGFloat = 6

    // MARK: - UI
    var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - thumbSize
            let lowerX = position(for: lower, trackWidth: trackWidth)
            let upperX = position(for: upper, trackWidth: trackWidth)

            ZStack(alignment: .leading) {
                // Full track
                Capsule()
                    .fill(Constants.Colors.gray01)
                    .frame(height: trackHeight)
                    .padding(.horizontal, thumbSize / 2)

                // Selected range
                Capsule()
                    .fill(Constants.Colors.yellow)
                    .frame(width: max(upperX - lowerX, 0), height: trackHeight)
                    .offset(x: lowerX + thumbSize / 2)

                thumb
                    .offset(x: lowerX)
                    .gesture(lowerDrag(trackWidth: trackWidth))

                thumb
                    .offset(x: upperX)
                    .gesture(upperDrag(trackWidth: trackWidth))
            }
        }
        .frame(height: thumbSize)
    }

    private var thumb: some View {
        Circle()
            .fill(Constants.Colors.white)
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 2)
            .overlay(Circle().stroke(Constants.Colors.gray01, lineWidth: 1))
    }

    // MARK: - Gestures

    private func lowerDrag(trackWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let start = lowerDragStart ?? lower
                lowerDragStart = start
                let proposed = start + valueChange(for: value.translation.width, trackWidth: trackWidth)
                lower = clamped(snapped(proposed), to: bounds.lowerBound...(upper - minGap))
            }
            .onEnded { _ in
                lowerDragStart = nil
            }
    }

    private func upperDrag(trackWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let start = upperDragStart ?? upper
                upperDragStart = start
                let proposed = start + valueChange(for: value.translation.width, trackWidth: trackWidth)
                upper = clamped(snapped(proposed), to: (lower + minGap)...bounds.upperBound)
            }
            .onEnded { _ in
                upperDragStart = nil
            }
    }

    // MARK: - Helpers

    /// Returns the x offset of a thumb for the given value.
    private func position(for value: Double, trackWidth: Double) -> Double {
        let span = bounds.upperBound - bounds.lowerBound
        guard span > 0 else { return 0 }
        return ((value - bounds.lowerBound) / span) * trackWidth
    }

    /// Returns how much the value changes for a horizontal drag distance
    private func valueChange(for translation: CGFloat, trackWidth: CGFloat) -> Double {
        guard trackWidth > 0 else { return 0 }
        let span = bounds.upperBound - bounds.lowerBound
        return Double(translation / trackWidth) * span
    }

    /// Returns the value rounded to the nearest step.
    private func snapped(_ value: Double) -> Double {
        (value / step).rounded() * step
    }

    /// Returns the value limited to the given range
    private func clamped(_ value: Double, to range: ClosedRange<Double>) -> Double {
        min(max(value, range.lowerBound), range.upperBound)
    }

}

#Preview {
    RangeSliderPreview()
}

private struct RangeSliderPreview: View {

    @State private var lower: Double = 6
    @State private var upper: Double = 22

    var body: some View {
        VStack(alignment: .leading) {
            // Text used to check values 
            Text("\(lower, specifier: "%.1f") - \(upper, specifier: "%.1f")")
            RangeSlider(lower: $lower, upper: $upper, bounds: 6...22, step: 0.5, minGap: 1)
        }
        .padding(16)
    }

}
