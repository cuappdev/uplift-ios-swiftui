//
//  CustomLoadingView.swift
//  Uplift
//
//  Created by jiwon jeong on 10/2/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct CustomLoadingView: View {

    @State private var isAnimating = false
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            pulsingBackground

            VStack(spacing: 30) {
                spinningLogoView
                loadingText
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(
                Animation.linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }

    private var pulsingBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Constants.Colors.black)
            .frame(width: 249, height: 271)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }

    private var spinningLogoView: some View {
        ZStack {
            spinningSpinner
            bobbingLogo
        }
    }

    private var spinningSpinner: some View {
        Constants.Images.spokes
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 175, height: 175)
            .rotationEffect(.degrees(rotation))
    }

    private var bobbingLogo: some View {
        Constants.Images.logoTransparent
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 176)
            .shadow(color: .orange.opacity(0.5), radius: 20)
            .offset(y: isAnimating ? -8 : 8)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }

    private var loadingText: some View {
        Text("Loading...")
            .foregroundStyle(Constants.Colors.white)
            .font(Constants.Fonts.f1)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .opacity(isAnimating ? 1.0 : 0.5)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }

}
