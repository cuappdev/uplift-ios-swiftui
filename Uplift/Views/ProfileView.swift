//
//  ProfileView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                RemindersView()
            } label: {
                Text("Reminders")
            }
        }
    }
}

#Preview {
    ProfileView()
}
