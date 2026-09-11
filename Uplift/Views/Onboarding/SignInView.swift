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

    static var hasShownIntro = false

    @StateObject private var viewModel = SignInAnimationViewModel(
        hasShownIntro: SignInView.hasShownIntro
    )

    // MARK: - UI

    var body: some View {
        ZStack {
            signInContent

            if viewModel.showIntro {
                IntroAnimationView(
                    onTransition: viewModel.transitionToSignIn,
                    onFinished: finishIntro
                )
            }

            mainLogo

        }
        .task {
            await viewModel.startIntroLogoAnimation()
        }
    }

    private var signInContent: some View {
        ZStack(alignment: .top) {
            Constants.Images.backgroundEllipse
                .resizable()
                .scaledToFit()
                .padding(.trailing, Constants.SignIn.backgroundTrailingPadding)
                .ignoresSafeArea(edges: .top)
                .opacity(animateElements ? 1 : 0)
                .animation(
                    .easeIn(duration: Constants.SignIn.backgroundFadeDuration)
                    .delay(Constants.SignIn.backgroundFadeDelay),
                    value: animateElements
                )

            VStack {
                signInHeader

                loginButton

                Spacer(minLength: Constants.SignIn.spacerMinLength)

                skipButton
            }
        }
        .background(Color.white)
        .onAppear {
            if viewModel.showIntro {
                var transaction = Transaction()
                transaction.disablesAnimations = true

                withTransaction(transaction) {
                    animateElements = true
                }
            } else {
                withAnimation(.easeIn(duration: Constants.SignIn.initialFadeDuration)) {
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
        .animation(
            .easeIn(duration: Constants.SignIn.contentFadeDuration)
            .delay(Constants.SignIn.contentFadeDelay),
            value: animateElements
        )
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
                .padding(.horizontal, Constants.SignIn.buttonHorizontalPadding)
                .padding(.vertical, Constants.SignIn.buttonVerticalPadding)
                .background(Constants.Colors.yellow)
                .cornerRadius(Constants.SignIn.buttonCornerRadius)
                .upliftShadow(Constants.Shadows.smallLight)
        }
        .opacity(animateElements ? 1 : 0)
        .animation(
            .easeIn(duration: Constants.SignIn.contentFadeDuration)
            .delay(Constants.SignIn.contentFadeDelay),
            value: animateElements
        )
    }

    private var cardsView: some View {
        VStack(spacing: Constants.SignIn.cardSpacing) {
            createGoalsView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : Constants.SignIn.cardYOffset)
                .animation(
                    .spring(duration: Constants.SignIn.contentFadeDuration)
                    .delay(Constants.SignIn.firstCardDelay),
                    value: animateElements
                )
            trackGoalsView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : Constants.SignIn.cardYOffset)
                .animation(
                    .spring(duration: Constants.SignIn.contentFadeDuration)
                    .delay(Constants.SignIn.secondCardDelay),
                    value: animateElements
                )
            workoutHistoryView
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : Constants.SignIn.cardYOffset)
                .animation(
                    .spring(duration: Constants.SignIn.contentFadeDuration)
                    .delay(Constants.SignIn.thirdCardDelay),
                    value: animateElements
                )
        }
        .padding(.horizontal, Constants.SignIn.cardsHorizontalPadding)
    }

    private var createGoalsView: some View {
        HStack {
            Constants.Images.goal

            Text("Create fitness goals")
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)

            Spacer()
        }
        .padding(Constants.SignIn.cardPadding)
        .background(.white)
        .cornerRadius(Constants.SignIn.cardCornerRadius)
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
        .padding(Constants.SignIn.cardPadding)
        .background(.white)
        .cornerRadius(Constants.SignIn.cardCornerRadius)
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
        .padding(Constants.SignIn.cardPadding)
        .background(.white)
        .cornerRadius(Constants.SignIn.cardCornerRadius)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var signInHeader: some View {
        VStack {

            Text("Find what uplifts you.")
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.black)
                .padding(.top, Constants.SignIn.headerTopPadding)
                .opacity(animateElements ? 1 : 0)
                .animation(
                    .easeIn(duration: Constants.SignIn.contentFadeDuration)
                    .delay(Constants.SignIn.contentFadeDelay),
                    value: animateElements
                )

            Text("Log in to:")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .padding(.top, Constants.SignIn.loginLabelTopPadding)
                .opacity(animateElements ? 1 : 0)
                .animation(
                    .easeIn(duration: Constants.SignIn.contentFadeDuration)
                    .delay(Constants.SignIn.contentFadeDelay),
                    value: animateElements
                )

            cardsView
                .padding(.top, Constants.SignIn.cardsTopPadding)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var mainLogo: some View {
        VStack {
            ZStack {
                Constants.Images.logoSunset
                    .resizable()
                    .scaledToFit()
                    .opacity(
                        viewModel.isTransitioningToSignIn
                            ? 0
                            : 1
                    )

                Constants.Images.logo
                    .resizable()
                    .scaledToFit()
                    .opacity(
                        viewModel.isTransitioningToSignIn
                            ? 1
                            : 0
                    )
            }
            .frame(
                width: viewModel.mainLogoSize.width,
                height: viewModel.mainLogoSize.height
            )
            .animation(
                .easeInOut(
                    duration: Constants.IntroAnimation.transitionDuration
                ),
                value: viewModel.isTransitioningToSignIn
            )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(
            .top,
            viewModel.mainLogoTopPadding
        )
        .offset(
            y: viewModel.mainLogoYOffset
        )
        .animation(
            .easeOut(
                duration: Constants.IntroAnimation.entranceDuration
            ),
            value: viewModel.introLogoEntered
        )
        .animation(
            .smooth(
                duration: Constants.IntroAnimation.transitionDuration
            ),
            value: viewModel.isTransitioningToSignIn
        )
    }

    private func finishIntro() {
        SignInView.hasShownIntro = true
        viewModel.finish()
    }
}

#Preview {
    SignInView()
}
