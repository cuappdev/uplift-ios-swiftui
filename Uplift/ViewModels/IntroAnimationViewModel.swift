//
//  IntroAnimationViewModel.swift
//  Uplift
//
//  Created by Kaylee Ulep on 9/11/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

final class IntroAnimationViewModel: ObservableObject {

    @Published var hasEntered = false
    @Published var isFadingOut = false

    func appDevLogoYOffset(for height: CGFloat) -> CGFloat {
        hasEntered ? 0 : height
    }

    @MainActor
    func startAnimation(
        for height: CGFloat,
        onTransition: (() -> Void)?,
        onFinished: (() -> Void)?
    ) async {
        guard height > 0 else { return }

        hasEntered = true

        try? await Task.sleep(
            for: .seconds(Constants.IntroAnimation.introDuration)
        )

        guard !Task.isCancelled else { return }

        withAnimation(
            .smooth(duration: Constants.IntroAnimation.transitionDuration)
        ) {
            isFadingOut = true
        }

        onTransition?()

        try? await Task.sleep(
            for: .seconds(Constants.IntroAnimation.transitionDuration)
        )

        guard !Task.isCancelled else { return }

        onFinished?()
    }
}
