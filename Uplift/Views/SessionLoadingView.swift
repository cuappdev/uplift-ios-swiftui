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
            background
            mountains
            appDevLogo
            logo
        }
        .ignoresSafeArea()
        .onAppear {
            isAnimating = true
        }
    }

    private var background: some View {
        Constants.Images.introBackground
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    private var mountains: some View {
        ZStack(alignment: .bottom) {
            Constants.Images.mountainBack
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()

            Constants.Images.mountainFront
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(1.2, anchor: .bottom)
        .offset(y: 40)
    }

    private var appDevLogo: some View {
        VStack {
            Spacer()

            Constants.Images.appDevLogoWhite
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constants.IntroAnimation.appDevLogoWidth,
                    height: Constants.IntroAnimation.appDevLogoHeight
                )
                .padding(.bottom, 60)
        }
    }

    private var logo: some View {
        VStack {
            Constants.Images.logoSunset
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constants.SignIn.enteredLogoWidth,
                    height: Constants.SignIn.enteredLogoHeight
                )
                .offset(y: isAnimating ? -8 : 8)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: Constants.SignIn.enteredLogoYOffset)
    }

}

#Preview {
    SessionLoadingView()
}
