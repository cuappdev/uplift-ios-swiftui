//
//  RemindersView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The main view for the Reminders page.
struct RemindersView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - UI

    var body: some View {
        NavigationStack {
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
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Reminders")
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
        VStack {
            NavigationLink {
                CapacityRemindersView()
            } label: {
                reminderRow(icon: Constants.Images.capacity, title: "Capacity Reminders")
            }

            NavigationLink {
                CheckInRemindersView()
            } label: {
                reminderRow(icon: Image(systemName: "location"), title: "Check-In Reminders")
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private func reminderRow(icon: Image, title: String) -> some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    icon
                        .foregroundStyle(Constants.Colors.black)
                        .frame(width: 24, height: 24)

                    Text(title)
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Constants.Colors.gray03)
                    .frame(width: 24, height: 24)
            }
            .padding(.vertical, 20)

            DividerLine()
        }
    }
}

#Preview {
    RemindersView()
}
