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

    // MARK: - Constants

    let transitionDuration: Double = 0.35

    private let transitionedLogoWidth: CGFloat = 130
    private let transitionedLogoHeight: CGFloat = 115

    private let enteredLogoWidth: CGFloat = 173.14737
    private let enteredLogoHeight: CGFloat = 152.79259

    private let transitionedLogoTopPadding: CGFloat = 10
    private let transitionedLogoYOffset: CGFloat = 15
    private let enteredLogoYOffset: CGFloat = 160
    private let hiddenLogoYOffset: CGFloat = 900

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
            ? CGSize(width: transitionedLogoWidth, height: transitionedLogoHeight)
            : CGSize(width: enteredLogoWidth, height: enteredLogoHeight)
    }

    var mainLogoTopPadding: CGFloat {
        isTransitioningToSignIn ? transitionedLogoTopPadding : 0
    }

    var mainLogoYOffset: CGFloat {
        if isTransitioningToSignIn {
            return transitionedLogoYOffset
        }

        if introLogoEntered {
            return enteredLogoYOffset
        }

        return hiddenLogoYOffset
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
            .smooth(duration: transitionDuration)
        ) {
            phase = .transitioningToSignIn
        }
    }

    @MainActor
    func finish() {
        phase = .finished
    }
}
