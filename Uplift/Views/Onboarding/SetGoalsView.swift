//
//  SetGoalsView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The view for setting goals and workout reminders.
struct SetGoalsView: View {

    // MARK: - Properties

    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @StateObject private var viewModel = ViewModel()
    @State private var isEveryDay = false
    @State private var isSettingTime = false
    @State private var showNewReminder = false

    // MARK: - UI

    var body: some View {
        NavigationStack {
            VStack {
                header
                content
            }
            .padding(.vertical, 20)
            .background(Constants.Colors.white)
        }
    }

    private var header: some View {
        VStack {
            HStack {
                Text("Set your goals.")
                    .font(Constants.Fonts.h1)
                    .padding(.leading, 16)

                Spacer()
            }

            DividerLine()
                .upliftShadow(Constants.Shadows.smallLight)
        }
    }

    private var content: some View {
        VStack(spacing: 48) {
            workoutDays
            // TODO: Workout reminders feature is archived for now
//                workoutReminders

            Spacer()

            nextLabel
        }
        .padding(
            EdgeInsets(
                top: Constants.Padding.goalsVertical,
                leading: Constants.Padding.goalsHorizontal,
                bottom: Constants.Padding.goalsVertical,
                trailing: Constants.Padding.goalsHorizontal
            )
        )
    }

    private var workoutDays: some View {
        VStack(spacing: 20) {
            HStack {
                Text("How many days a week would you like to work out?")
                    .font(Constants.Fonts.f2)

                Spacer()
            }
            .foregroundStyle(Constants.Colors.black)

            VStack(spacing: 16) {
                Slider(
                    value: $viewModel.daysAWeek,
                    in: 1...7,
                    step: 1
                )
                .tint(Constants.Colors.yellow)
                .frame(height: 8)

                HStack {
                    ForEach(1...7, id: \.self) { day in
                        Text("\(day)")

                        day < 7 ? Spacer() : nil
                    }
                }
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.bodyBold)
                .padding(.horizontal, 10)
            }
        }
    }

    private var workoutReminders: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                HStack {
                    Text("WORKOUT REMINDERS")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h2)

                    Spacer()
                }

                HStack {
                    Text("Get reminders on workout days to stay on track!")
                        .foregroundStyle(Constants.Colors.gray04)
                        .font(Constants.Fonts.f3)

                    Spacer()
                }
            }

            newReminder

            !showNewReminder ? reminders : nil
        }
    }

    private var newReminder: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Button {
                    withAnimation {
                        showNewReminder.toggle()
                    }
                } label: {
                    Constants.Images.addCircle
                        .renderingMode(.template)
                        .foregroundStyle(showNewReminder ? Constants.Colors.gray01 : Constants.Colors.black)

                    Text("New Reminder")
                        .foregroundStyle(showNewReminder ? Constants.Colors.gray01 : Constants.Colors.black)
                        .font(Constants.Fonts.f2)
                }
                .disabled(showNewReminder)

                Spacer()
            }

            showNewReminder ? WorkoutReminderEditView(inEditMode: $showNewReminder, isNew: false) : nil
        }
    }

    private var reminders: some View {
        VStack(spacing: 24) {
            ForEach(viewModel.reminders, id: \.self) { reminder in
                WorkoutReminderView(
                    isAllDay: reminder.isAllDay,
                    selectedDays: reminder.selectedDays,
                    time: reminder.time
                )
            }
        }
    }

    private var nextLabel: some View {
        Button {
            // TODO: Fix animation
            withAnimation {
                mainViewModel.showSetGoalsView = false
                mainViewModel.showCreateProfileView = true
            }
        } label: {
            Text("Next")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)
                .padding(.horizontal, 52)
                .padding(.vertical, 12)
                .background(Constants.Colors.yellow)
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)
        }
    }

}

#Preview {
    SetGoalsView()
}
