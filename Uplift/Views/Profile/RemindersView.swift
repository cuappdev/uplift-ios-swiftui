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
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavBackButton(color: Constants.Colors.black, dismiss: dismiss)
                }
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
        .background(Constants.Colors.gray00)
        .frame(height: 96)
    }

    private var content: some View {
        VStack {
            NavigationLink {
                RemindersView()
            } label: {
                capacityReminders
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private var capacityReminders: some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    Constants.Images.capacity

                    Text("Capacity Reminders")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Constants.Colors.gray03)
                    .frame(width: 24, height: 24)
            }
            .padding(.vertical, 24)

            DividerLine()
        }
    }
}

#Preview {
    RemindersView()
}
