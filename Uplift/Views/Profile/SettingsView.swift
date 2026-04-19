//
//  SettingsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 3/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @EnvironmentObject private var tabBarProp: TabBarProperty
    let onBack: () -> Void
    let onFinishedReporting: () -> Void
    let onAbout: () -> Void
    let onReminders: () -> Void
    let onLogout: () -> Void
    let onDeleteAccount: () -> Void

    // MARK: - UI

    var body: some View {
        VStack {
            header
            content
        }
        .ignoresSafeArea(.all, edges: .top)
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    onBack()
                } label: {
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Constants.Colors.black)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Settings")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }
        }
        .padding(.bottom, 8)
        .background(Constants.Colors.lightGray)
        .frame(height: 96)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            Button {
                onAbout()
            } label: {
                HStack {
                    Constants.Images.aboutLogo
                        .frame(width: 24, alignment: .center)

                    Text("About Uplift")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)

                    Spacer()

                    Constants.Images.chevronRight
                        .frame(width: 24, alignment: .center)
                }
            }

            DividerLine()

            NavigationLink {
                ReportView(onReturnToProfile: onFinishedReporting)
                    .environmentObject(tabBarProp)
            } label: {
                HStack {
                    Constants.Images.reportLogo
                        .frame(width: 24, alignment: .center)

                    Text("Report an Issue")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)

                    Spacer()

                    Constants.Images.chevronRight
                        .frame(width: 24, alignment: .center)
                }
            }
            .buttonStyle(.plain)

            DividerLine()

            Button {
                onLogout()
            } label: {
                HStack {
                    Constants.Images.logoutLogo
                        .frame(width: 24, alignment: .center)

                    Text("Log Out")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.closed)

                    Spacer()
                }
            }

            DividerLine()

            Button {
                onDeleteAccount()
            } label: {
                HStack {
                    Constants.Images.deleteLogo
                        .frame(width: 24, alignment: .center)

                    Text("Delete Account")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.closed)

                    Spacer()
                }
            }

            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .background(Constants.Colors.white)
    }
}

#Preview {
    SettingsView(
        onBack: {},
        onFinishedReporting: {},
        onAbout: {},
        onReminders: {},
        onLogout: {},
        onDeleteAccount: {}
    )
    .environmentObject(TabBarProperty())
}
