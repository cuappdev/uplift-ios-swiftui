//
//  CapacityTutorialModal.swift
//  Uplift
//
//  Created by jiwon jeong on 10/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct CapacityTutorialModal: View {

    @State private var logoOffset: CGFloat = 200
    @State private var logoOpacity: Double = 0

    let onFinish: () -> Void
    let onSetUp: () -> Void

    var body: some View {
        VStack {
            header

            content
        }
        .frame(width: 300, height: 563)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                logoOffset = 0
                logoOpacity = 1
            }
        }
    }

    private var header: some View {
        Constants.Images.backgroundTutorial
            .resizable()
            .frame(height: 175)
            .overlay(alignment: .center) {
                Constants.Images.logoTransparent
                    .resizable()
                    .frame(width: 250, height: 250)
                    .offset(y: logoOffset)
                    .opacity(logoOpacity)
            }
            .overlay(alignment: .topTrailing) {
                Button(action: onFinish) {
                    Constants.Images.crossThin
                        .offset(x: -15, y: 15)
                }
            }
    }

    private var content: some View {
        VStack {
            Text("Introducing a new feature:")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.f3)
                .padding(.bottom, 5)

            Text("Capacity Reminders!")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.h2)
                .padding(.bottom, 10)

            Text("Get real-time alerts for whenever your favorite gyms are free!")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.bodyLight)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)

            Text("Tap the button below to get started!")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.labelLight)
                .padding(.bottom, 12)

            Constants.Images.capacityTutorial
                .padding(.bottom, 24)

            NavigationLink {
                 CapacityRemindersView()
            } label: {
                Text("Set up now")
                    .frame(width: 250, height: 41)
                    .foregroundStyle(Constants.Colors.white)
                    .font(Constants.Fonts.h3)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Constants.Colors.black)
                    )
            }
            .simultaneousGesture(TapGesture().onEnded {
                onSetUp()
            })
            .padding(.bottom, 8)

            Button {
                onFinish()
            } label: {
                Text("Maybe later")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
            }
            .padding(.bottom, 20)

        }
        .frame(height: 388)
    }
}
