//
//  RangeSlider.swift
//  Uplift
//
//  Created by Sandy Yang on 10/7/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A slider with two thumbs used to select a range of values. 
struct RangeSlider: View {

    // MARK: - Properties

    @Binding var lower: Double
    @Binding var upper: Double
    @StateObject private var viewModel: ViewModel

    private let thumbSize: CGFloat = 24
    private let trackHeight: CGFloat = 6

    init(
        lower: Binding<Double>,
        upper: Binding<Double>,
        bounds: ClosedRange<Double>,
        step: Double,
        minGap: Double
    ) {
        _lower = lower
        _upper = upper
        _viewModel = StateObject(wrappedValue: ViewModel(bounds: bounds, step: step, minGap: minGap))
    }

    // MARK: - UI
    var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - thumbSize
            let lowerX = viewModel.position(for: lower, trackWidth: trackWidth)
            let upperX = viewModel.position(for: upper, trackWidth: trackWidth)

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
                    .gesture(viewModel.lowerDrag(trackWidth: trackWidth, lower: $lower, upper: $upper))

                thumb
                    .offset(x: upperX)
                    .gesture(viewModel.upperDrag(trackWidth: trackWidth, lower: $lower, upper: $upper))
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
}
