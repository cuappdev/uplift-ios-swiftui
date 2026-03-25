//
//  SettingsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 3/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//
import SwiftUI

struct SettingsView: View {
    let onBack: () -> Void
    let onReportIssue: () -> Void
    let onAbout: () -> Void
    let onReminders: () -> Void
    let onLogout: () -> Void

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
                    Text("About Uplift")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    
                    Spacer()
                }
            }

            DividerLine()

            Button {
                onReminders()
            } label: {
                HStack {
                    Text("Reminders")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                }
            }

            DividerLine()

            Button {
                onReportIssue()
            } label: {
                HStack {
                    Text("Report an Issue")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                }
            }

            DividerLine()

            Button {
                onLogout()
            } label: {
                Text("Log Out")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.closed)
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
        onReportIssue: {},
        onAbout: {},
        onReminders: {},
        onLogout: {}
    )
}
