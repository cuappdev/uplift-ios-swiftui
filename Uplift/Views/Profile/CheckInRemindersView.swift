//
//  CheckInRemindersView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/26/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The view for the Check-In Reminders page.
struct CheckInRemindersView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    // MARK: - UI

    var body: some View {
        VStack {
            header
            content
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            HStack {
                NavBackButton(color: Constants.Colors.black, dismiss: dismiss)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Constants.Colors.white)
        .task {
            await viewModel.refreshNotificationSettings()
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Check-In Reminders")
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("CHECK-IN REMINDERS")
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.h3)

                Toggle("", isOn: $viewModel.isEnabled.animation())
                    .tint(Constants.Colors.yellow)
                    .onChange(of: viewModel.isEnabled) { newValue in
                        viewModel.handleToggleChange(isOn: newValue)
                    }
            }

            Text("Uplift will send you a notification when you get to a gym so you can check in")
                .foregroundStyle(Constants.Colors.gray03)
                .font(Constants.Fonts.labelNormal)
                .multilineTextAlignment(.leading)

            viewModel.notificationsDenied ? notificationsNote : nil
            viewModel.needsAlwaysLocation ? locationNote : nil

            Spacer()
        }
        .padding(
            EdgeInsets(
                top: Constants.Padding.remindersVertical,
                leading: Constants.Padding.remindersHorizontal,
                bottom: Constants.Padding.remindersVertical,
                trailing: Constants.Padding.remindersHorizontal
            )
        )
    }

    private var notificationsNote: some View {
        Text("Notifications are off for Uplift, turn them on in Settings to get reminders")
            .foregroundStyle(Constants.Colors.closed)
            .font(Constants.Fonts.labelNormal)
    }

    private var locationNote: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Set location to Always in Settings so Uplift can tell when you get to a gym")
                .foregroundStyle(Constants.Colors.closed)
                .font(Constants.Fonts.labelNormal)

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            } label: {
                Text("Open Settings")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h4)
            }
        }
    }

}

#Preview {
    CheckInRemindersView()
}
