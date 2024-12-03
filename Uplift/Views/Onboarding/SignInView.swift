//
//  SignInView.swift
//  Uplift
//
//  Created by Belle Hu on 9/14/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SignInView: View {

    // MARK: - Properties

    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @State private var animateElements: Bool = false

    // MARK: - UI

    var body: some View {
        ZStack {
            VStack {
                signInHeader
                loginButton

                Spacer(minLength: 16)

                skipButton
            }
        }
        .background(Color.white)
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                animateElements = true
            }
        }
    }

    private var skipButton: some View {
        Button {
            withAnimation(.easeIn) {
                mainViewModel.showMainView = true
            }
        } label: {
            Text("Skip")
                .font(Constants.Fonts.bodyNormal)
                .foregroundColor(Constants.Colors.gray04)
        }
        .opacity(animateElements ? 1 : 0)
        .animation(.easeIn(duration: 1).delay(2), value: animateElements)
    }

    private var loginButton: some View {
        Button {
            loginViewModel.googleSignIn { email, name, netId in
                mainViewModel.email = email
                mainViewModel.name = name
                mainViewModel.netID = netId
                mainViewModel.createUser()
                mainViewModel.showSignInView = false
                mainViewModel.showCreateProfileView = true
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
        .opacity(animateElements ? 1 : 0)
        .animation(.easeIn(duration: 1).delay(2), value: animateElements)
    }

    private var cardsView: some View {
        VStack(spacing: 12) {
            createGoalsView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 200)
                .animation(.spring(duration: 1).delay(2.5), value: animateElements)
            trackGoalsView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 200)
                .animation(.spring(duration: 1).delay(3), value: animateElements)
            workoutHistoryView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 200)
                .animation(.spring(duration: 1).delay(3.5), value: animateElements)
        }
        .padding(.horizontal, 76)
    }

    private var createGoalsView: some View {
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

    private var trackGoalsView: some View {
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

    private var workoutHistoryView: some View {
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
                    .opacity(animateElements ? 1 : 0)
                    .animation(.easeIn(duration: 1).delay(1), value: animateElements)

                Constants.Images.logo
                    .resizable()
                    .frame(width: 130, height: 115)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(32)
                    .offset(y: animateElements ? 0 : 200)
                    .animation(.smooth(duration: 2), value: animateElements)
            }

            Text("Find what uplifts you.")
                .font(Constants.Fonts.h1)
                .padding(.top, 62)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(2), value: animateElements)

            Text("Log in to:")
                .font(Constants.Fonts.h2)
                .padding(.top, 89)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(2), value: animateElements)

            cardsView
                .padding(.top, 24)

            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignInView()
}
