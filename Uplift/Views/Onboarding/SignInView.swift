//
//  SignInView.swift
//  Uplift
//
//  Created by Belle Hu on 9/14/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import OSLog
import SwiftUI

struct SignInView: View {

    // MARK: - Properties

    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var animateElements: Bool = false
    @State private var showIntro = !SignInView.hasShownIntro

    static var hasShownIntro = false
    @State private var introLogoEntered = false
    @State private var isTransitioningToSignIn = false

    // MARK: - UI

    var body: some View {
        ZStack {
            signInContent

            if showIntro {
                IntroAnimationView(
                    onTransition: {
                        withAnimation(.smooth(duration: 0.7)) {
                            isTransitioningToSignIn = true
                        }
                    },
                    onFinished: {
                        SignInView.hasShownIntro = true
                        showIntro = false
                    }
                )
            }

            mainLogo
        }
        .onAppear {
            if showIntro {
                DispatchQueue.main.async {
                    introLogoEntered = true
                }
            }
        }
    }

    private var signInContent: some View {
        ZStack(alignment: .top) {
            Constants.Images.backgroundEllipse
                .resizable()
                .scaledToFit()
                .padding(.trailing, 51)
                .ignoresSafeArea(edges: .top)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(1), value: animateElements)

            VStack {
                signInHeader

                loginButton

                Spacer(minLength: 16)

                skipButton
            }
        }
        .background(Color.white)
        .onAppear {
            if showIntro {
                var transaction = Transaction()
                transaction.disablesAnimations = true

                withTransaction(transaction) {
                    animateElements = true
                }
            } else {
                withAnimation(.easeIn(duration: 0.3)) {
                    animateElements = true
                }
            }
        }
    }

    private var skipButton: some View {
        Button {
            withAnimation(.easeIn) {
                mainViewModel.isSkipped = true
                mainViewModel.showSignInView = false
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

                UserSessionManager.shared.loginUser(netId: netId) { result in
                    switch result {
                    case .success:
                        Task {
                            await MainActor.run {
                                mainViewModel.isSkipped = false
                                mainViewModel.showSignInView = false
                                mainViewModel.showCreateProfileView = false
                                mainViewModel.showMainView = true
                            }
                        }

                        UserSessionManager.shared.email = email

                    case .failure(let error):
                        if let graphqlError = error as? GraphQLErrorWrapper,
                           graphqlError.msg.contains("No user with those credentials") {

                            Task {
                                await MainActor.run {
                                    mainViewModel.isSkipped = false
                                    mainViewModel.showSignInView = false
                                    mainViewModel.showSetGoalsView = false
                                    mainViewModel.showCreateProfileView = true
                                }
                            }
                        } else {
                            Logger.data.critical("Unexpected login error: \(error.localizedDescription)")
                        }
                    }
                }
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
                .foregroundStyle(Constants.Colors.black)

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
                .foregroundStyle(Constants.Colors.black)

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
                .foregroundStyle(Constants.Colors.black)

            Spacer()
        }
        .padding(12)
        .background(.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var signInHeader: some View {
        VStack {

            Color.clear // to give enough space for logo!
                .frame(height: 115)
                .padding(32)
                .padding(.top, 10)

            Text("Find what uplifts you.")
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.black)
                .padding(.top, 62)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(2), value: animateElements)

            Text("Log in to:")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .padding(.top, 89)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(2), value: animateElements)

            cardsView
                .padding(.top, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var mainLogo: some View {
        VStack {
            Constants.Images.logo
                .resizable()
                .scaledToFit()
                .frame(
                    width: logoWidth,
                    height: logoHeight
                )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, logoTopPadding)
        .offset(y: logoYOffset)
        .animation(.easeOut(duration: 1.0), value: introLogoEntered)
        .animation(.smooth(duration: 0.7), value: isTransitioningToSignIn)
    }

    // helpers
    private var logoWidth: CGFloat {
        isTransitioningToSignIn ? 130 : 173.14737
    }

    private var logoHeight: CGFloat {
        isTransitioningToSignIn ? 115 : 152.79259
    }

    private var logoTopPadding: CGFloat {
        isTransitioningToSignIn ? 10 : 0
    }

    private var logoYOffset: CGFloat {
        if isTransitioningToSignIn {
            return 15
        }

        return introLogoEntered ? 160 : 900
    }
}

#Preview {
    SignInView()
}
