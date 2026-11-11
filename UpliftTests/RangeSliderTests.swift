//
//  RangeSliderViewModelTests.swift
//  Uplift
//
//  Created by Sandy Yang on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation
import Testing
@testable import Uplift

struct RangeSliderViewModelTests {

    /**
     bounds: 6 to 22, so the track covers 16 hours
     step: 0.5, values snap to the nearest half hour
     minGap: 1, the thumbs stay at least 1 hour apart

     the track is 320 pt wide so 1 hour is 20 pt and the drag distances are easy to work out
     a new instance of this struct is made for every test so no drag state carries over
     */
    private let viewModel = RangeSlider.ViewModel(bounds: 6...22, step: 0.5, minGap: 1)
    private let trackWidth: CGFloat = 320

    @Test("Lower bound sits at the start of the track")
    func positionAtLowerBound() {
        #expect(viewModel.position(for: 6, trackWidth: trackWidth) == 0)
    }

    @Test("Upper bound sits at the end of the track")
    func positionAtUpperBound() {
        #expect(viewModel.position(for: 22, trackWidth: trackWidth) == trackWidth)
    }

    @Test("Halfway value sits in the middle of the track")
    func positionInMiddle() {
        #expect(viewModel.position(for: 14, trackWidth: trackWidth) == 160)
    }

    @Test("Lower thumb snaps to the nearest step")
    func lowerSnapsToStep() {
        let value = viewModel.lowerValue(dragTranslation: 28, trackWidth: trackWidth, start: 6, upper: 22)
        #expect(value == 7.5)
    }

    @Test("Lower thumb stops 1 hour before the upper thumb")
    func lowerStopsAtMinGap() {
        let value = viewModel.lowerValue(dragTranslation: 320, trackWidth: trackWidth, start: 6, upper: 8)
        #expect(value == 7)
    }

    @Test("Lower thumb cannot go below the bounds")
    func lowerStopsAtLowerBound() {
        let value = viewModel.lowerValue(dragTranslation: -100, trackWidth: trackWidth, start: 8, upper: 22)
        #expect(value == 6)
    }

    @Test("Upper thumb stops 1 hour after the lower thumb")
    func upperStopsAtMinGap() {
        let value = viewModel.upperValue(dragTranslation: -320, trackWidth: trackWidth, lower: 20, start: 22)
        #expect(value == 21)
    }

    @Test("Upper thumb cannot go above the bounds")
    func upperStopsAtUpperBound() {
        let value = viewModel.upperValue(dragTranslation: 200, trackWidth: trackWidth, lower: 6, start: 20)
        #expect(value == 22)
    }

    @Test("Thumbs closer than the minimum gap stay put instead of crashing")
    func narrowGapDoesNotCrash() {
        let value = viewModel.lowerValue(dragTranslation: 20, trackWidth: trackWidth, start: 6, upper: 6.5)
        #expect(value == 6)
    }

}
