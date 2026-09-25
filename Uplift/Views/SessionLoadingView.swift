//
//  SessionLoadingView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/24/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// loading screen shown while the previous session is restored
struct SessionLoadingView: View {

    // MARK: - Properties

    @State private var isAnimating = false

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.white

            logo

            appDevLogo
        }
        .ignoresSafeArea()
        .task {
            try? await Task.sleep(for: Constants.SessionLoading.bobStartDelay)
            withAnimation(
                .easeInOut(duration: Constants.SessionLoading.bobDuration).repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }

    private var logo: some View {
        Constants.Images.logo
            .resizable()
            .scaledToFit()
            .frame(
                width: Constants.SessionLoading.logoSize,
                height: Constants.SessionLoading.logoSize
            )
            .offset(y: isAnimating ? Constants.SessionLoading.bobOffset : 0)
    }

    private var appDevLogo: some View {
        Constants.Images.appdevLogo
            .resizable()
            .scaledToFit()
            .frame(height: Constants.IntroAnimation.appDevLogoHeight)
            .padding(.bottom, Constants.SessionLoading.appDevLogoBottomPadding)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }

}

#Preview {
    SessionLoadingView()
}
