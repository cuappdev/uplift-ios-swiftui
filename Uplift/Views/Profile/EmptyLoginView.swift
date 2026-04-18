//
//  EmptyLoginView.swift
//  Uplift
//
//  Created by jiwon jeong on 4/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import OSLog
import SwiftUI

/// Profile-tab prompt when the user skipped account sign-in (`MainViewModel.isSkipped`).
struct EmptyLoginView: View {

    // MARK: - Properties

    @EnvironmentObject private var mainViewModel: MainView.ViewModel
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var animateElements = false

    // MARK: - UI

    var body: some View {
        ZStack {
            VStack {

                headerSection

                Spacer()

                loginButton

                Spacer(minLength: 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                animateElements = true
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Constants.Images.backgroundEllipse
                    .padding(.trailing, 51)
                    .opacity(animateElements ? 1 : 0)
                    .animation(.easeIn(duration: 1).delay(0.2), value: animateElements)

                Constants.Images.logo
                    .resizable()
                    .frame(width: 130, height: 115)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(32)
                    .offset(y: animateElements ? 0 : 200)
                    .animation(.smooth(duration: 2), value: animateElements)
            }

            Text("Get started with Uplift")
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.center)
                .padding(.top, 28)
                .padding(.horizontal, Constants.Padding.homeHorizontal)
                .opacity(animateElements ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(0.6), value: animateElements)

            featureCards
                .padding(.top, 24)
                .padding(.bottom, 24)

            Spacer(minLength: 0)
        }
        .ignoresSafeArea(edges: .top)
    }

    private var featureCards: some View {
        VStack(spacing: 12) {
            createGoalsCard
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 24)
                .animation(.spring(duration: 0.8).delay(0.8), value: animateElements)

            trackProgressCard
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 24)
                .animation(.spring(duration: 0.8).delay(0.95), value: animateElements)

            historyCard
                .opacity(animateElements ? 1 : 0)
                .offset(y: animateElements ? 0 : 24)
                .animation(.spring(duration: 0.8).delay(1.1), value: animateElements)
        }
        .padding(.horizontal, 48)
    }

    private var createGoalsCard: some View {
        HStack(spacing: 12) {
            Constants.Images.goal

            Text("Create fitness goals")
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Constants.Colors.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var trackProgressCard: some View {
        HStack(spacing: 12) {
            Constants.Images.gymSimple

            Text("Track fitness progress")
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Constants.Colors.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var historyCard: some View {
        HStack(spacing: 12) {
            Constants.Images.history

            Text("View workout history")
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Constants.Colors.white)
        .cornerRadius(8)
        .upliftShadow(Constants.Shadows.smallLight)
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
        .animation(.easeIn(duration: 0.8).delay(1.2), value: animateElements)
    }
}

#Preview {
    EmptyLoginView()
        .environmentObject(MainView.ViewModel())
}
