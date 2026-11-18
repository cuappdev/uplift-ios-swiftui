//
//  RangeSliderViewModel.swift
//  Uplift
//
//  Created by Sandy Yang on 10/28/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension RangeSlider {

    /// The ViewModel for the range slider.
    class ViewModel: ObservableObject {

        // MARK: - Properties
        var bounds: ClosedRange<Double>
        let step: Double
        let minGap: Double

        // MARK: - Functions

        init(bounds: ClosedRange<Double>, step: Double, minGap: Double) {
            self.bounds = bounds
            self.step = step
            self.minGap = minGap
        }

        /// Returns the x offset of a thumb for the given value.
        func position(for value: Double, trackWidth: CGFloat) -> CGFloat {
            let span = bounds.upperBound - bounds.lowerBound
            guard span > 0 else { return 0 }
            return CGFloat((value - bounds.lowerBound) / span) * trackWidth
        }

        /// Returns the new lower value after the lower thumb has been dragged by the given distance from 'start'.
        func lowerValue(dragTranslation: CGFloat, trackWidth: CGFloat, start: Double, upper: Double) -> Double {
            let proposed = start + valueChange(for: dragTranslation, trackWidth: trackWidth)
            return clamped(snapped(proposed), min: bounds.lowerBound, max: upper - minGap)
        }

        /// Returns the new upper value after the upper thumb has been dragged by the given distance from 'start'.
        func upperValue(dragTranslation: CGFloat, trackWidth: CGFloat, lower: Double, start: Double) -> Double {
            let proposed = start + valueChange(for: dragTranslation, trackWidth: trackWidth)
            return clamped(snapped(proposed), min: lower + minGap, max: bounds.upperBound)
        }

        /// Returns the gesture that moves the lower thumb, writing the new value into `lower`.
        func lowerDrag(
            trackWidth: CGFloat,
            start: GestureState<Double?>,
            lower: Binding<Double>,
            upper: Binding<Double>
        ) -> some Gesture {
            DragGesture()
                .updating(start) { _, state, _ in
                    state = state ?? lower.wrappedValue
                }
                .onChanged { [self] value in
                    lower.wrappedValue = lowerValue(
                        dragTranslation: value.translation.width,
                        trackWidth: trackWidth,
                        start: start.wrappedValue ?? lower.wrappedValue,
                        upper: upper.wrappedValue
                    )
                }
        }

        /// Returns the gesture that moves the upper thumb, writing the new value into `upper`.
        func upperDrag(
            trackWidth: CGFloat,
            start: GestureState<Double?>,
            lower: Binding<Double>,
            upper: Binding<Double>
        ) -> some Gesture {
            DragGesture()
                .updating(start) { _, state, _ in
                    state = state ?? upper.wrappedValue
                }
                .onChanged { [self] value in
                    upper.wrappedValue = upperValue(
                        dragTranslation: value.translation.width,
                        trackWidth: trackWidth,
                        lower: lower.wrappedValue,
                        start: start.wrappedValue ?? upper.wrappedValue
                    )
                }
        }

        // MARK: - Helpers

        /// Returns how much the value changes for a horizontal drag distance.
        private func valueChange(for translation: CGFloat, trackWidth: CGFloat) -> Double {
            guard trackWidth > 0 else { return 0 }
            let span = bounds.upperBound - bounds.lowerBound
            return Double(translation / trackWidth) * span
        }

        /// Returns the value rounded to the nearest step.
        private func snapped(_ value: Double) -> Double {
            (value / step).rounded() * step
        }

        /// Returns the value limited to the given minimum and maximum.
        private func clamped(_ value: Double, min lo: Double, max hi: Double) -> Double {
            Swift.max(lo, Swift.min(value, hi))
        }
    }
}
