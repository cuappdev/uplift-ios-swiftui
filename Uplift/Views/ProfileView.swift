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
            NavigationLink {
                RemindersView()
            } label: {
                Text("Reminders")
            }

            NavigationLink {
                ReportView()
            } label: {
                Text("Report an issue")
            }
        }
    }
}

#Preview {
    ProfileView()
}
