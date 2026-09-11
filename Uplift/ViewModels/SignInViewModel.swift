//
//  SignInViewModel.swift
//  Uplift
//
//  Created by Kaylee Ulep on 9/11/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

final class SignInAnimationViewModel: ObservableObject {

    // MARK: - Properties

    @Published var introLogoEntered = false
    @Published var isTransitioningToSignIn = false

    // MARK: - Logo Properties

    var mainLogoSize: CGSize {
        isTransitioningToSignIn
            ? CGSize(width: 130, height: 115)
            : CGSize(width: 173.14737, height: 152.79259)
    }

    var mainLogoTopPadding: CGFloat {
        isTransitioningToSignIn ? 10 : 0
    }

    var mainLogoYOffset: CGFloat {
        if isTransitioningToSignIn {
            return 15
        }

        if introLogoEntered {
            return 160
        }

        return 900
    }

    // MARK: - Animation

    @MainActor
    func startIntroLogoAnimation(showIntro: Bool) async {
        guard showIntro else { return }

        await Task.yield()
        introLogoEntered = true
    }

    @MainActor
    func transitionToSignIn() {
        withAnimation(
            .smooth(duration: Constants.IntroAnimation.transitionDuration)
        ) {
            isTransitioningToSignIn = true
        }
    }
}
