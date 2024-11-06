//
//  WorkoutReminderEditView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/2/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing the edit state of a workout reminder.
struct WorkoutReminderEditView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @State private var isEveryDay = false
    let isNew: Bool
    @State private var isSettingTime = false
    @Binding var inEditMode: Bool

    // MARK: - Initalizer

    init(inEditMode: Binding<Bool> = .constant(false), isNew: Bool) {
        self._inEditMode = inEditMode
        self.isNew = isNew
    }

    // MARK: - UI

    var body: some View {
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

                deleteButton
                doneButton

                Spacer()
            }
        }
    }

    private var deleteButton: some View {
        Button {
            if isNew {
                // If this is a new reminder, clear and reset
                isEveryDay = false
                isSettingTime = false
                withAnimation {
                    inEditMode = false
                }
            } else {
                // If this is an existing reminder, delete the reminder
                // TODO: Implement deleting reminders
                withAnimation {
                    inEditMode = false
                }
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
    }

    private var doneButton: some View {
        Button {
            if isNew {
                // If this is a new reminder, add this new reminder
                isEveryDay = false
                isSettingTime = false
                withAnimation {
                    inEditMode = false
                }
                // TODO: Implement creating a reminder
            } else {
                // If this is an existing reminder, update the reminder
                // TODO: Implement updating a reminder
                withAnimation {
                    inEditMode = false
                }
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
