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

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    RemindersView()
                } label: {
                    Text("Reminders")
                }
            }
            // TODO: Temporary to allow view to take up whole screen
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Constants.Colors.white)
        }
    }

}

#Preview {
    ProfileView()
}
