//
//  SignInView.swift
//  Uplift
//
//  Created by Belle Hu on 9/14/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some View {

        VStack {
            signInHeader
            login
            Spacer(minLength: 16)
            skip
        }
    }

    private var skip: some View {
        Button {
            // TODO: Action
        } label: {
            Text("Skip")
                .font(Constants.Fonts.bodyNormal)
                .foregroundColor(Constants.Colors.gray04)
        }
    }
    private var login: some View {
        Button {
            loginViewModel.googleSignIn {
                mainViewModel.userDidLogin = true
            }
        } label: {
            Text("Log in")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)
                .padding(.horizontal, 46)
                .padding(.vertical, 12)
                .background(Constants.Colors.yellow)
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)
        }
    }

    private var cards: some View {
        VStack(spacing: 12) {
            goals
            gymSimple
            history
        }
        .padding(.horizontal, 76)
    }

    private var goals: some View {
        HStack {
            Constants.Images.goal
            Text("Create fitness goals")
                .font(Constants.Fonts.f2)
            Spacer()
        }
        .padding(12)
        .background(.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }
    private var gymSimple: some View {
        HStack {
            Constants.Images.gymSimple
            Text("Track fitness goals")
                .font(Constants.Fonts.f2)
            Spacer()
        }
        .padding(12)
        .background(.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }
    private var history: some View {
        HStack {
            Constants.Images.history
            Text("View workout history")
                .font(Constants.Fonts.f2)
            Spacer()
        }
        .padding(12)
        .background(.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }
    private var signInHeader: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Constants.Images.backgroundEllipse
                    .padding(.trailing, 51)
                Constants.Images.logo
                    .resizable()
                    .frame(width: 130, height: 115)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(32)

            }
            Text("Find what uplifts you.")
                .font(Constants.Fonts.h1)
                .padding(.top, 62)

            Text("Log in to:")
                .font(Constants.Fonts.h2)
                .padding(.top, 89)

            cards
                .padding(.top, 24)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignInView()
}
