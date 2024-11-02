//
//  WorkoutReminderView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/1/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing a workout reminder.
struct WorkoutReminderView: View {

    // MARK: - Properties

    let isAllDay: Bool
    let selectedDays: [DayOfWeek]
    let time: String
    @State private var isOn = true

    // MARK: - UI

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack {
                    Text("Wednesday")
                        .foregroundStyle(isOn ? Constants.Colors.black : Constants.Colors.gray03)
                        .font(Constants.Fonts.reminder)
                }
                .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Constants.Colors.gray01, lineWidth: 1)
                )

                Spacer()

                Toggle("", isOn: $isOn.animation())
                    .tint(Constants.Colors.yellow)
                    .labelsHidden()
            }

            HStack {
                Text("3:00 PM")
                    .foregroundStyle(isOn ? Constants.Colors.black : Constants.Colors.gray03)
                    .font(Constants.Fonts.bodyBold)

                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Constants.Colors.white)
        )
        .upliftShadow(Constants.Shadows.smallLight)
    }

}

// TODO: Temporary Reminder model
struct WorkoutReminder: Hashable {
    let selectedDays: [DayOfWeek]
    let isAllDay: Bool
    let time: String
}

//#Preview {
//    WorkoutReminder()
//}
