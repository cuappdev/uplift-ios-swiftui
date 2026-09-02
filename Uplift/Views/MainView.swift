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
    @EnvironmentObject private var viewModel: ViewModel // NOTE: MainViewModel is EnvironmentObject for now (many screens need it)
    @StateObject private var profileViewModel = ProfileView.ViewModel() // NOTE: We only need to drill this to few screens so using @StateObject & @ObservedObject pattern
    @StateObject private var homeViewModel = HomeView.ViewModel() // NOTE: We only need to drill this to few screens so using @StateObject & @ObservedObject pattern
    @State private var selectedTab: Screen = .home
    @StateObject var tabBarProp = TabBarProperty()

    // MARK: - UI

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeView(popUpGiveaway: $viewModel.popUpGiveaway, viewModel: homeViewModel)
                case .classes:
                    ClassesView()
                        .environmentObject(tabBarProp)
                case .profile:
                    Group {
                        if viewModel.isSkipped {
                            EmptyLoginView()
                        } else {
                            ProfileView(viewModel: profileViewModel)
                                .environmentObject(tabBarProp)
                        }
                    }
                    .environmentObject(viewModel) // MainViewModel
                }
            }
            .overlay(alignment: .bottom) {
                VStack {
                    if !viewModel.isSkipped {
                        WorkoutCheckInView(
                            profileViewModel: profileViewModel,
                            homeViewModel: homeViewModel
                        )
                        .environmentObject(viewModel) // MainViewModel
                        .padding(.bottom, 13)
                        .padding(.horizontal, 10)
                        .opacity(viewModel.showWorkoutCheckIn ? 1 : 0)
                    }

                    !tabBarProp.hidden ? tabBar.transition(.move(edge: .bottom)) : nil
                }
            }

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
        .background(Color.white)
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

            tabItem(for: .classes)

            Spacer()

            tabItem(for: .profile)

            Spacer()
        }
        .frame(height: Constants.Padding.tabBarHeight)
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
                tabItemView(
                    icon: selectedTab == .home ? Constants.Images.dumbbellSolid : Constants.Images.dumbbellOutline,
                    name: "Home"
                )
            }
        case .classes:
            Button {
                selectedTab = .classes
            } label: {
                tabItemView(
                    icon: selectedTab == .classes ? Constants.Images.whistleSolid : Constants.Images.whistleOutline,
                    name: "Classes"
                )
            }
        case .profile:
            Button {
                selectedTab = .profile
            } label: {
                tabItemView(
                    icon: selectedTab == .profile ? Constants.Images.profileSolid : Constants.Images.profileOutline,
                    name: "Profile"
                )
            }
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
        case classes
        case profile
    }

}

final class TabBarProperty: ObservableObject {
    @Published var hidden: Bool = false
}

#Preview {
    MainView()
}
