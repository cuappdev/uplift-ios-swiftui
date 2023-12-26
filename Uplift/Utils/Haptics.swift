//
//  Haptics.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import UIKit

/// Provides haptic feedback as a response to tap gestures.
class Haptics {

    static let shared = Haptics()

    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

}
