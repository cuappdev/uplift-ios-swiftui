//
//  SignInViewModel.swift
//  Uplift
//
//  Created by Kaylee Ulep on 9/11/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

final class SignInAnimationViewModel: ObservableObject {

    // MARK: - Phase

    enum Phase {
        case hidden
        case entered
        case transitioningToSignIn
        case finished
    }

    @Published var phase: Phase

    init(hasShownIntro: Bool) {
        phase = hasShownIntro ? .finished : .hidden
    }

    // MARK: - Computed Properties

    var showIntro: Bool {
        phase != .finished
    }

    var introLogoEntered: Bool {
        switch phase {
        case .entered, .transitioningToSignIn, .finished:
            return true
        case .hidden:
            return false
        }
    }

    var isTransitioningToSignIn: Bool {
        switch phase {
        case .transitioningToSignIn, .finished:
            return true
        case .hidden, .entered:
            return false
        }
    }

    var mainLogoSize: CGSize {
        isTransitioningToSignIn
        ? CGSize(width: Constants.SignIn.transitionedLogoWidth, height: Constants.SignIn.transitionedLogoHeight)
        : CGSize(width: Constants.SignIn.enteredLogoWidth, height: Constants.SignIn.enteredLogoHeight)
    }

    var mainLogoTopPadding: CGFloat {
        isTransitioningToSignIn ? Constants.SignIn.transitionedLogoTopPadding : 0
    }

    var mainLogoYOffset: CGFloat {
        if isTransitioningToSignIn {
            return Constants.SignIn.transitionedLogoYOffset
        }

        if introLogoEntered {
            return Constants.SignIn.enteredLogoYOffset
        }

        return Constants.SignIn.hiddenLogoYOffset
    }

    // MARK: - Animation

    @MainActor
    func startIntroLogoAnimation() async {
        guard phase == .hidden else { return }

        await Task.yield()

        phase = .entered
    }

    @MainActor
    func transitionToSignIn() {
        withAnimation(
            .smooth(duration: Constants.IntroAnimation.transitionDuration)
        ) {
            phase = .transitioningToSignIn
        }
    }

    @MainActor
    func finish() {
        phase = .finished
    }
}
