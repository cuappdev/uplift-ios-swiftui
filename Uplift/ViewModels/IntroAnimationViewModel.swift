//
//  IntroAnimationViewModel.swift
//  Uplift
//
//  Created by Kaylee Ulep on 9/11/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

final class IntroAnimationViewModel: ObservableObject {

    // MARK: - Properties

    @Published var hasEntered = false
    @Published var isFadingOut = false

    // MARK: - Constants
    let introDuration: Double = 1.5
    let transitionDuration: Double = 0.35

    // MARK: - Helpers

    func appDevLogoYOffset(for height: CGFloat) -> CGFloat {
        hasEntered ? 0 : height
    }

    // MARK: - Animation

    @MainActor
    func startAnimation(
        for height: CGFloat,
        onTransition: (() -> Void)?,
        onFinished: (() -> Void)?
    ) async {
        guard height > 0 else { return }

        hasEntered = true

        try? await Task.sleep(
            for: .seconds(introDuration)
        )

        guard !Task.isCancelled else { return }

        withAnimation(
            .smooth(duration: transitionDuration)
        ) {
            isFadingOut = true
        }

        onTransition?()

        try? await Task.sleep(
            for: .seconds(transitionDuration)
        )

        guard !Task.isCancelled else { return }

        onFinished?()
    }
}
