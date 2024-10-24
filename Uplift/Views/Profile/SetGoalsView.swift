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
            VStack(spacing: 48) {
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

            showNewReminder ? createReminderCard : nil
        }
    }

    private var createReminderCard: some View {
        VStack(spacing: 24) {
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    reminderDays

                    Button {
                        withAnimation {
                            isEveryDay.toggle()
                            viewModel.setEveryDay(isEveryDay)
                        }
                    } label: {
                        HStack(spacing: 12) {
                            isEveryDay ? Constants.Images.checkboxFilled : Constants.Images.checkboxEmpty

                            Text("Every Day")
                                .foregroundStyle(Constants.Colors.gray04)
                                .font(Constants.Fonts.bodySemibold)

                            Spacer()
                        }
                    }
                }

                setTime
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Constants.Colors.white)
            )
            .upliftShadow(Constants.Shadows.smallLight)

            HStack(spacing: 8) {
                Spacer()

                Button {
                    isEveryDay = false
                    isSettingTime = false
                    withAnimation {
                        showNewReminder.toggle()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Constants.Images.trash

                        Text("Delete")
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.h3)
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Constants.Colors.white)
                }
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)

                Button {
                    // TODO: Implement adding a reminder
                    isEveryDay = false
                    isSettingTime = false
                    withAnimation {
                        showNewReminder.toggle()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Constants.Images.check

                        Text("Done")
                            .foregroundStyle(Constants.Colors.white)
                            .font(Constants.Fonts.h3)
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Constants.Colors.black)
                }
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)

                Spacer()
            }
        }
    }

    private var reminderDays: some View {
        HStack {
            ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                Text(day.dayOfWeekAbbreviation())
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(viewModel.selectedDays.contains(day)
                                  ? Constants.Colors.yellow
                                  : Constants.Colors.gray00)
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.selectedDays.contains(day)
                                ? viewModel.selectedDays.removeAll { $0 == day }
                                : viewModel.selectedDays.append(day)
                        }
                    }

                day != DayOfWeek.sunday ? Spacer() : nil
            }
        }
        .font(Constants.Fonts.h3)
        .foregroundStyle(Constants.Colors.black)
    }

    private var setTime: some View {
        VStack(spacing: 28) {
            HStack(spacing: 16) {
                Text("Set Time")
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.h3)

                Toggle("", isOn: $isSettingTime.animation())
                    .tint(Constants.Colors.yellow)
                    .labelsHidden()

                !isSettingTime ? (
                    Text("Default is 9:00 am")
                        .foregroundStyle(Constants.Colors.gray04)
                        .font(Constants.Fonts.labelNormal)
                ) : nil

                Spacer()
            }

            isSettingTime ? (
                HStack {
                    Picker("", selection: $viewModel.hour) {
                        ForEach(1...12, id: \.self) { hour in
                            Text("\(hour)")
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.picker)
                                .background(Constants.Colors.white)
                        }
                    }
                    .frame(width: 68, height: 118)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Constants.Colors.gray01, lineWidth: 1)
                    )

                    Picker("", selection: $viewModel.minutes) {
                        ForEach(0...55, id: \.self) { hour in
                            hour % 5 == 0 ? (
                                Text(String(format: "%02d", hour))
                                    .foregroundStyle(Constants.Colors.black)
                                    .font(Constants.Fonts.picker)
                                    .background(Constants.Colors.white)
                            ) : nil
                        }
                    }
                    .frame(width: 68, height: 118)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Constants.Colors.gray01, lineWidth: 1)
                    )

                    Picker("", selection: $viewModel.timeSuffix) {
                        ForEach(["AM", "PM"], id: \.self) { timeSuffix in
                            Text(timeSuffix)
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.h2)
                                .background(Constants.Colors.white)
                        }
                    }
                    .frame(width: 56, height: 118)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
            ) : nil
        }
    }
}

#Preview {
    SetGoalsView()
}
