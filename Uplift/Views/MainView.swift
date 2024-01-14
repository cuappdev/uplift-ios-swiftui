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

    // MARK: - UI

    var body: some View {
        HomeView()
        // TODO: Temporarily remove tab bar for release
//        ZStack(alignment: .bottom) {
//            TabView(selection: $selectedTab) {
//                HomeView()
//                    .tag(Screen.home)
//            }
//
//            tabBar
//        }
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
