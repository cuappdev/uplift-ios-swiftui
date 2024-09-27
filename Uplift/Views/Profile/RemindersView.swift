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
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavBackButton(color: Constants.Colors.black, dismiss: dismiss)
                }
            }
            .background(Constants.Colors.gray01)
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Text("Reminders")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h1)

                Spacer()
            }
        }
        .padding(
            EdgeInsets(
                top: 0,
                leading: Constants.Padding.homeHorizontal,
                bottom: 12,
                trailing: Constants.Padding.homeHorizontal
            )
        )
        .background(
            Constants.Colors.white
                .upliftShadow(Constants.Shadows.smallLight)
        )
        .ignoresSafeArea(.all)
        .frame(height: 64)
    }
}

#Preview {
    RemindersView()
}
