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

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.white

            logo

            spinner

            appDevLogo
        }
        .ignoresSafeArea()
    }

    private var logo: some View {
        Constants.Images.logo
            .resizable()
            .scaledToFit()
            .frame(
                width: Constants.SessionLoading.logoSize,
                height: Constants.SessionLoading.logoSize
            )
    }

    private var spinner: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Constants.Colors.gray03))
            .offset(y: Constants.SessionLoading.spinnerOffset)
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
