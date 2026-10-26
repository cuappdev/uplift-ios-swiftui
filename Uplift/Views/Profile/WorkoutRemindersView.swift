//
//  WorkoutRemindersView.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/23/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A screen for managing workout reminders.
struct WorkoutRemindersView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = WorkoutReminderViewModel()

    @State private var showNewReminder = false
    @State private var editingReminder: WorkoutReminder?
    @State private var inSavedState = false

    // MARK: - UI

    var body: some View {
        VStack {
            header
            content
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            HStack {
                NavBackButton(color: Constants.Colors.black, dismiss: dismiss)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Constants.Colors.white)
        .onAppear {
            viewModel.loadReminders()
        }
        .onChange(of: viewModel.reminders) { _ in
            if viewModel.hasUnsavedChanges {
                inSavedState = false
            }
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Workout Reminders")
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
            VStack(spacing: 32) {
                workoutReminders

                if inSavedState {
                    savedLabel
                } else {
                    saveButton
                }
            }
        }
    }

    // MARK: - Workout Reminders

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

            if !showNewReminder {
                reminderList
            }
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
                        .foregroundStyle(
                            (showNewReminder || editingReminder != nil)
                                ? Constants.Colors.gray01
                                : Constants.Colors.black
                        )

                    Text("New Reminder")
                        .foregroundStyle(
                            (showNewReminder || editingReminder != nil)
                                ? Constants.Colors.gray01
                                : Constants.Colors.black
                        )
                        .font(Constants.Fonts.f2)
                }
                .disabled(showNewReminder || editingReminder != nil)

                Spacer()
            }

            if showNewReminder {
                WorkoutReminderEditView(
                    inEditMode: $showNewReminder,
                    isNew: true,
                    onCreate: { reminder in
                        viewModel.addReminder(reminder)
                    }
                )
            }
        }
    }

    private var reminderList: some View {
        VStack(spacing: 24) {
            ForEach(viewModel.reminders) { reminder in
                if editingReminder == nil ||
                    editingReminder?.id == reminder.id {

                    WorkoutReminderCardView(
                        editingReminder: $editingReminder,
                        reminder: reminder,
                        onToggle: { isEnabled in
                            viewModel.toggleReminder(
                                reminder,
                                isEnabled: isEnabled
                            )
                        },
                        onUpdate: { updatedReminder in
                            withAnimation(
                                .easeInOut(
                                    duration: Constants.Goals.animationDuration
                                )
                            ) {
                                viewModel.updateReminder(updatedReminder)
                            }
                        },
                        onDelete: {
                            withAnimation(
                                .easeInOut(
                                    duration: Constants.Goals.animationDuration
                                )
                            ) {
                                viewModel.deleteReminder(reminder)
                                editingReminder = nil
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Save Changes

    private var saveButton: some View {
        Button {
            withAnimation {
                viewModel.saveReminders()
                inSavedState = true
            }
        } label: {
            Text("Save Changes")
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    viewModel.hasUnsavedChanges
                        ? Constants.Colors.black
                        : Constants.Colors.gray03
                )
                .cornerRadius(30)
                .upliftShadow(Constants.Shadows.smallLight)
        }
        .disabled(!viewModel.hasUnsavedChanges)
    }

    private var savedLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 12, height: 12)

            Text("Saved")
                .font(Constants.Fonts.h3)
        }
        .foregroundStyle(Constants.Colors.white)
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(Constants.Colors.gray03)
        .cornerRadius(30)
        .upliftShadow(Constants.Shadows.smallLight)
    }
}
