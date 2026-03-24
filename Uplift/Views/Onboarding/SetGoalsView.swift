//
//  SetGoalsView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import OSLog

/// The view for setting goals and workout reminders.
struct SetGoalsView: View {

    // MARK: - Properties

    let isOnboarding: Bool
    let user: User?

    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ViewModel()
    @State private var isEveryDay = false
    @State private var isSettingTime = false
    @State private var showNewReminder = false
    @State private var inSavedState = false

    private var isGoalChangeLocked: Bool {
        viewModel.isGoalChangeLocked(lastGoalChange: user?.lastGoalChange)
    }

    // MARK: - Init

    init(isOnboarding: Bool, user: User? = nil) {
        self.isOnboarding = isOnboarding
        self.user = user
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            if isOnboarding {
                VStack {
                    header
                    content
                }
                .padding(.vertical, 20)
                .background(Constants.Colors.white)
            } else {
                VStack {
                    headerInProfile
                    content
                }
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Constants.Images.arrowLeftLight
                                .resizable()
                                .scaledToFill()
                                .foregroundStyle(Constants.Colors.black)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .background(Constants.Colors.white)
            }
        }
        .onAppear {
            guard !isOnboarding, let user = user else { return }
            viewModel.sliderWorkoutGoal = Double(user.workoutGoal ?? 1)
            viewModel.currWorkoutGoal = user.workoutGoal ?? 1
            inSavedState = isGoalChangeLocked   // ensures saved state is locked if still cannot be changed
        }
        .showModal($viewModel.showWarningModal) {
            GoalSettingModal(
                onContinue: {
                    if let user = user {
                        viewModel.setWorkoutGoal(
                            userId: Int(user.id) ?? 0,
                            workoutGoal: Int(viewModel.sliderWorkoutGoal)
                        ) { result in
                            switch result {
                            case .success:
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    inSavedState = true
                                    viewModel.currWorkoutGoal = Int(viewModel.sliderWorkoutGoal)
                                }
                            case .failure(let error):
                                Logger.data.critical("Error in SetGoalsView: \(error.localizedDescription)")
                            }
                        }
                    }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.showWarningModal = false
                    }
                },
                onCancel: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.showWarningModal = false
                    }
                }
            )
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

    private var headerInProfile: some View {
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
        .padding(.bottom, 10)
        .background(Constants.Colors.lightGray)
        .frame(height: 96)
    }

    private var content: some View {
        VStack(spacing: 40) {
            workoutDays
            // TODO: Workout reminders feature is archived for now
//                workoutReminders

            if !isOnboarding {
                if inSavedState {
                    savedLabel
                } else {
                    saveButton
                }
            }

            Spacer()

            if isOnboarding {
                nextButton
            }
        }
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
                    value: $viewModel.sliderWorkoutGoal,
                    in: 1...7,
                    step: 1
                )
                .tint(Constants.Colors.yellow)
                .frame(height: 8)
                .disabled(!isOnboarding && isGoalChangeLocked)

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
        .padding(
            EdgeInsets(
                top: Constants.Padding.goalsVertical,
                leading: Constants.Padding.goalsHorizontal,
                bottom: Constants.Padding.goalsVertical,
                trailing: Constants.Padding.goalsHorizontal
            )
        )
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

    private var saveButton: some View {
        Button {
            withAnimation {
                viewModel.showWarningModal = true
            }
        } label: {
            Text("Save Changes")
                .font(Constants.Fonts.h3)
                .foregroundColor(Constants.Colors.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(viewModel.isWorkoutGoal ? Constants.Colors.gray03 : Constants.Colors.black)
                .cornerRadius(30)
                .upliftShadow(Constants.Shadows.smallLight)
        }
        .disabled(viewModel.isWorkoutGoal)
    }

    private var savedLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(Constants.Colors.white)

            Text("Saved")
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.white)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(viewModel.isWorkoutGoal ? Constants.Colors.gray03 : Constants.Colors.black)
        .cornerRadius(30)
        .upliftShadow(Constants.Shadows.smallLight)
    }

    private var nextButton: some View {
        Button {
            mainViewModel.createUser {
                guard let userId = mainViewModel.userId else { return }
                viewModel.setWorkoutGoal(
                    userId: userId,
                    workoutGoal: Int(viewModel.sliderWorkoutGoal)
                ) { result in
                    switch result {
                    case .success:
                        withAnimation {
                            mainViewModel.showSetGoalsView = false
                            mainViewModel.showMainView = true
                        }
                    case .failure(let error):
                        Logger.data.critical("Error in SetGoalsView: \(error.localizedDescription)")
                    }
                }
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
    SetGoalsView(isOnboarding: true)
}
