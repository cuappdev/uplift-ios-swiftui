//
//  ProfileView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The main view for the Profile page.
struct ProfileView: View {

    // MARK: - Properties

    @State var isActive = true
    @State var reportIsActive = false
    @State var reportSuccessIsActive = false
    @EnvironmentObject var tabBarProp: TabBarProperty

    // MARK: - UI

    var body: some View {
        ZStack {
            isActive ? (
                NavigationStack {
                    NavigationLink {
                        RemindersView()
                    } label: {
                        Text("Reminders")
                    }

                    Button {
                        withAnimation(.easeIn(duration: 0.3)) {
                            isActive.toggle()
                            reportIsActive.toggle()
                        }
                        withAnimation(.easeIn(duration: 0.1)) {
                            tabBarProp.hidden = true
                        }
                    } label: {
                        Text("Report an issue")
                    }
                }
            ) : nil

            reportIsActive ? ReportView(
                isActive: $reportIsActive,
                profileIsActive: $isActive,
                reportSuccessIsActive: $reportSuccessIsActive
            )
            .environmentObject(tabBarProp)
            .transition(.move(edge: .trailing)) : nil

            reportSuccessIsActive ? ReportSuccessView(
                isActive: $reportSuccessIsActive,
                profileIsActive: $isActive,
                reportIsActive: $reportIsActive
            )
            .environmentObject(tabBarProp) : nil
        }
        // TODO: Temporary to allow view to take up whole screen
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.white)
    }

}

#Preview {
    ProfileView()
}
