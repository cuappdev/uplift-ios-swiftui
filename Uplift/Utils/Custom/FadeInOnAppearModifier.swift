//
//  FadeInOnAppearModifier.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/31/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view modifier that fades a view in when it appears.
struct FadeInOnAppearModifier: ViewModifier {

    @State private var isVisible = false

    let delay: Double
    let duration: Double

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: duration).delay(delay)) {
                    isVisible = true
                }
            }
    }

}

extension View {

    func fadeInOnAppear(
        delay: Double = Constants.WorkoutInProgress.contentFadeDelay,
        duration: Double = Constants.WorkoutInProgress.contentFadeDuration
    ) -> some View {
        modifier(FadeInOnAppearModifier(delay: delay, duration: duration))
    }

}
