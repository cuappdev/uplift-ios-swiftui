//
//  PushedScreenModifier.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/8/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PushedScreenModifier: ViewModifier {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    let title: String

    // MARK: - UI

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            header
            content
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Constants.Colors.white)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack {
            Spacer()

            ZStack {
                Text(title)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                HStack {
                    backButton

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.Padding.homeHorizontal)
        .padding(.bottom, Constants.PushedScreen.headerBottomPadding)
        .frame(height: Constants.PushedScreen.headerHeight)
        .background(Constants.Colors.lightGray)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Constants.Images.arrowLeftLight
                .resizable()
                .scaledToFill()
                .foregroundStyle(Constants.Colors.black)
                .frame(width: Constants.PushedScreen.backButtonSize, height: Constants.PushedScreen.backButtonSize)
        }
    }

}

extension View {

    func pushedScreen(title: String) -> some View {
        modifier(PushedScreenModifier(title: title))
    }

}
