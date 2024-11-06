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

    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
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

                Text("Goals")
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
        ScrollView {
            LazyVStack(spacing: 48) {
                workoutDays
                workoutReminders

                Spacer()
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
    }

    private var workoutDays: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Let’s set a plan! ")
                    .font(Constants.Fonts.h2)
                +
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

}

#Preview {
    SetGoalsView()
}
