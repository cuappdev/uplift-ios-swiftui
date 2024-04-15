//
//  MainView.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The app's entry point view.
struct MainView: View {

    // MARK: - Properties

    @State private var selectedTab: Screen = .home
    @StateObject private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        ZStack {
            HomeView(popUpGiveaway: $viewModel.popUpGiveaway)
            // TODO: Temporarily remove tab bar for release
            //        ZStack(alignment: .bottom) {
            //            TabView(selection: $selectedTab) {
            //                HomeView()
            //                    .tag(Screen.home)
            //            }
            //
            //            tabBar
            //        }

            if viewModel.popUpGiveaway {
                Constants.Colors.gray04
                    .opacity(0.4)
                    .ignoresSafeArea(.all)

                GiveawayPopup(
                    didClickSubmit: $viewModel.didClickSubmit,
                    instagram: $viewModel.instagram,
                    netID: $viewModel.netID,
                    popUpGiveaway: $viewModel.popUpGiveaway,
                    submitSuccessful: $viewModel.submitSuccessful
                )
                .padding(.horizontal, 20)
                .transition(.scale(scale: 0.5, anchor: .bottom))
                .transition(.opacity)
                .alert(isPresented: $viewModel.showGiveawayErrorAlert) {
                    Alert(
                        title: Text("Unable to enter giveaway"),
                        message: Text("Something went wrong.")
                    )
                }
            }
        }
        .onChange(of: viewModel.didClickSubmit) { didClickSubmit in
            if didClickSubmit {
                viewModel.enterGiveaway()
            }
        }
    }

    private var tabBar: some View {
        HStack {
            Spacer()

            tabItem(for: .home)

            Spacer()
        }
        .frame(height: 64)
        .background(Constants.Colors.yellow)
        .ignoresSafeArea(.all)
    }

    @ViewBuilder
    private func tabItem(for screen: Screen) -> some View {
        switch screen {
        case .home:
            Button {
                selectedTab = .home
            } label: {
                tabItemView(icon: Constants.Images.dumbbellSmall, name: "Home")
            }
            .buttonStyle(.plain)
        }
    }

    private func tabItemView(icon: Image, name: String) -> some View {
        VStack {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Text(name)
                .font(Constants.Fonts.h3)
        }
        .foregroundStyle(Constants.Colors.black)
    }

}

extension MainView {

    /// An enumeration to keep track of which tab the user is currently on.
    private enum Screen {
        case home
    }

}

#Preview {
    MainView()
}
