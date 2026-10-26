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

    let isNew: Bool
    let onCreate: (WorkoutReminder) -> Void
    let onUpdate: (WorkoutReminder) -> Void
    let onDelete: () -> Void
    let reminder: WorkoutReminder?

    @State private var isSettingTime = false
    @Binding var inEditMode: Bool

    private var isEveryDay: Bool {
        viewModel.selectedDays.count == 7
    }

    // MARK: - Initalizer

    init(
        inEditMode: Binding<Bool> = .constant(false),
        isNew: Bool,
        onCreate: @escaping (WorkoutReminder) -> Void = { _ in },
        onUpdate: @escaping (WorkoutReminder) -> Void = { _ in },
        onDelete: @escaping () -> Void = {},
        reminder: WorkoutReminder? = nil
    ) {
        self._inEditMode = inEditMode
        self.isNew = isNew
        self.onCreate = onCreate
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self.reminder = reminder
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: Constants.WorkoutReminders.editorSpacing) {
            VStack(spacing: Constants.WorkoutReminders.editorContentSpacing) {
                VStack(spacing: Constants.WorkoutReminders.editorDaysSpacing) {
                    reminderDays

                    Button {
                        withAnimation {
                            viewModel.setEveryDay(!isEveryDay)
                        }
                    } label: {
                        HStack(spacing: Constants.WorkoutReminders.everyDaySpacing) {
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
            .padding(Constants.WorkoutReminders.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.WorkoutReminders.cardCornerRadius)
                    .fill(Constants.Colors.white)
            )
            .upliftShadow(Constants.Shadows.smallLight)
            .onAppear {
                if !isNew, let reminder {
                    viewModel.loadReminder(reminder)
                    isSettingTime = !reminder.isAllDay
                }
            }

            HStack(spacing: Constants.WorkoutReminders.editorButtonSpacing) {
                Spacer()

                deleteButton
                doneButton

                Spacer()
            }
        }
    }

    // MARK: - Action Buttons
    private var deleteButton: some View {
        Button {
            if isNew {
                // If this is a new reminder, clear and reset
                viewModel.setEveryDay(false)
                isSettingTime = false
                withAnimation {
                    inEditMode = false
                }
            } else {
                // If this is an existing reminder, delete the reminder
                onDelete()
                withAnimation {
                    inEditMode = false
                }
            }
        } label: {
            HStack(spacing: Constants.WorkoutReminders.editorButtonSpacing) {
                Constants.Images.trash

                Text("Delete")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
            }
            .padding(.vertical, Constants.WorkoutReminders.editorButtonVerticalPadding)
            .padding(.horizontal, Constants.WorkoutReminders.editorButtonHorizontalPadding)
            .background(Constants.Colors.white)
        }
        .cornerRadius(Constants.WorkoutReminders.editorButtonCornerRadius)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var doneButton: some View {
        Button {

            let newReminder = viewModel.makeReminder(
                isSettingTime: isSettingTime,
                isEnabled: reminder?.isEnabled ?? true,
                id: reminder?.id ?? UUID()
            )

            if isNew {
                // If this is a new reminder, add this new reminder
                onCreate(newReminder)
            } else {
                // If this is an existing reminder, update the reminder
                onUpdate(newReminder)
            }

            withAnimation {
                inEditMode = false
            }
        } label: {
            HStack(spacing: Constants.WorkoutReminders.editorButtonSpacing) {
                Constants.Images.check

                Text("Done")
                    .foregroundStyle(Constants.Colors.white)
                    .font(Constants.Fonts.h3)
            }
            .padding(.vertical, Constants.WorkoutReminders.editorButtonVerticalPadding)
            .padding(.horizontal, Constants.WorkoutReminders.editorButtonHorizontalPadding)
            .background(
                viewModel.selectedDays.isEmpty
                    ? Constants.Colors.gray03
                    : Constants.Colors.black
            )
        }
        .disabled(viewModel.selectedDays.isEmpty)
        .cornerRadius(Constants.WorkoutReminders.editorButtonCornerRadius)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    // MARK: - Reminder Configuration
    private var reminderDays: some View {
        HStack {
            ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                Text(day.dayOfWeekAbbreviation())
                    .frame(width: Constants.WorkoutReminders.dayCircleSize, height: Constants.WorkoutReminders.dayCircleSize)
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
        VStack(spacing: Constants.WorkoutReminders.editorContentSpacing) {
            HStack(spacing: Constants.WorkoutReminders.setTimeSpacing) {
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
                    .frame(width: Constants.WorkoutReminders.timePickerWidth, height: Constants.WorkoutReminders.timePickerHeight)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.WorkoutReminders.timePickerCornerRadius)
                            .stroke(Constants.Colors.gray01, lineWidth: Constants.WorkoutReminders.timePickerBorderWidth)
                    )

                    Picker("", selection: $viewModel.minutes) {
                        ForEach(
                            Array(stride(from: 0, through: 55, by: Constants.WorkoutReminders.minuteInterval)),
                            id: \.self
                        ) { minute in
                            Text(String(format: "%02d", minute))
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.picker)
                                .background(Constants.Colors.white)
                        }
                    }
                    .frame(width: Constants.WorkoutReminders.timePickerWidth, height: Constants.WorkoutReminders.timePickerHeight)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.WorkoutReminders.timePickerCornerRadius)
                            .stroke(Constants.Colors.gray01, lineWidth: Constants.WorkoutReminders.timePickerBorderWidth)
                    )

                    Picker("", selection: $viewModel.timeSuffix) {
                        ForEach(["AM", "PM"], id: \.self) { timeSuffix in
                            Text(timeSuffix)
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.h2)
                                .background(Constants.Colors.white)
                        }
                    }
                    .frame(width: Constants.WorkoutReminders.timePickerWidth, height: Constants.WorkoutReminders.timePickerHeight)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
            ) : nil
        }
    }
}
