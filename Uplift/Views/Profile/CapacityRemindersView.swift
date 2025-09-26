//
//  CapacityRemindersView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import WrappingHStack

/// The view for the Capacity Reminders page.
struct CapacityRemindersView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss

    private let gyms = ["TEAGLEUP", "TEAGLEDOWN", "HELENNEWMAN", "TONIMORRISON", "NOYES"]

    init() {
        if let savedId = UserDefaults.standard.object(forKey: "savedReminderId") as? Int {
            _viewModel = StateObject(wrappedValue: ViewModel(savedReminderId: savedId))
        }
    }

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
                    Button(action: {
                        viewModel.checkForUnsavedChanges()
                        if !viewModel.hasUnsavedChanges {
                            dismiss()
                        } else {
                            viewModel.showUnsavedChangesModal = true
                        }
                    }) {
                        Constants.Images.arrowLeft
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(Constants.Colors.black)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .background(Constants.Colors.white)
            .onAppear {
                viewModel.getFCMToken()
                viewModel.saveOriginalValues()
            }
            .overlay(
                Group {
                    if viewModel.showUnsavedChangesModal {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.showUnsavedChangesModal = false
                                    }
                                }

                            UnsavedChangesModal(
                                onSaveChanges: {
                                    viewModel.saveReminder {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            viewModel.showUnsavedChangesModal = false
                                            dismiss()
                                        }
                                    }
                                },
                                onContinue: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.showInfo = viewModel.originalShowInfo
                                        viewModel.selectedDays = viewModel.originalSelectedDays
                                        viewModel.capacityThreshold = viewModel.originalCapacityThreshold
                                        viewModel.selectedLocations = viewModel.originalSelectedLocations
                                        viewModel.hasUnsavedChanges = false
                                        viewModel.showUnsavedChangesModal = false
                                        dismiss()
                                    }
                                },
                                onCancel: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.showUnsavedChangesModal = false
                                    }
                                }
                            )
                            .transition(.opacity)
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.showUnsavedChangesModal)
            )
        }
        .loading(viewModel.isLoading)
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Capacity Reminders")
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
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("CAPACITY REMINDERS")
                        .foregroundStyle(Constants.Colors.gray04)
                        .font(Constants.Fonts.h3)

                    Toggle("", isOn: $viewModel.showInfo.animation())
                        .tint(Constants.Colors.yellow)
                        .onChange(of: viewModel.showInfo) { newValue in
                            viewModel.handleToggleChange(isOn: newValue)
                        }
                }

                Text("Uplift will send you a notification when gyms dip below the set capacity")
                    .foregroundStyle(Constants.Colors.gray03)
                    .font(Constants.Fonts.labelNormal)
                    .multilineTextAlignment(.leading)
            }

            viewModel.showInfo ? reminderInfo : nil

            Spacer()
        }
        .padding(
            EdgeInsets(
                top: Constants.Padding.remindersVertical,
                leading: Constants.Padding.remindersHorizontal,
                bottom: Constants.Padding.remindersVertical,
                trailing: Constants.Padding.remindersHorizontal
            )
        )
    }

    private var reminderInfo: some View {
        VStack(spacing: 16) {
            reminderDays
            capacityThreshold
            locationsToRemind
            saveButton
        }
        .padding(.vertical, 16)
    }

    private var reminderDays: some View {
        VStack(spacing: 16) {
            HStack {
                Text("REMINDER DAYS")
                    .foregroundStyle(Constants.Colors.gray03)
                    .font(Constants.Fonts.h4)

                Spacer()
            }

            HStack(spacing: 20) {
                ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                    Text(day.dayOfWeekAbbreviation())
                        .frame(width: 24, height: 24)
                        .background {
                            if viewModel.selectedDays.contains(day) {
                                Circle()
                                    .fill(Constants.Colors.yellow)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                if viewModel.selectedDays.contains(day) {
                                    viewModel.selectedDays.removeAll { $0 == day }
                                } else {
                                    viewModel.selectedDays.append(day)
                                }
                                viewModel.checkForUnsavedChanges()
                            }
                        }
                }
            }
            .font(Constants.Fonts.h4)
            .foregroundStyle(Constants.Colors.black)
            .padding(.vertical, 4)
        }
    }

    private var capacityThreshold: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("CAPACITY THRESHOLD")
                        .foregroundStyle(Constants.Colors.gray03)
                        .font(Constants.Fonts.h4)

                    Spacer()
                }

                GeometryReader { geometry in
                    HStack {
                        Text("\(Int(viewModel.capacityThreshold))%")
                            .foregroundStyle(Constants.Colors.gray04)
                            .font(Constants.Fonts.bodySemibold)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Constants.Colors.gray00)
                            }
                            .position(x: viewModel.capacityThreshold / 99 * (geometry.size.width - 32) + 16)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 12)

                Slider(
                    value: $viewModel.capacityThreshold,
                    in: 0...100,
                    step: 10
                )
                .tint(Constants.Colors.yellow)
                .frame(height: 8)
                .onChange(of: viewModel.capacityThreshold) { _ in
                    viewModel.checkForUnsavedChanges()
                }

                HStack {
                    Text("0%")

                    Spacer()

                    Text("100%")
                }
                .foregroundStyle(Constants.Colors.gray04)
                .font(Constants.Fonts.bodySemibold)
            }
        }
    }

    private var locationsToRemind: some View {
        VStack(spacing: 16) {
            HStack {
                Text("LOCATIONS TO REMIND")
                    .foregroundStyle(Constants.Colors.gray03)
                    .font(Constants.Fonts.h4)

                Spacer()
            }

            WrappingHStack(gyms, id: \.self, spacing: .constant(16)) { gym in
                Text(gym)
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.labelSemibold)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                viewModel.selectedLocations.contains(gym)
                                ? Constants.Colors.lightYellow
                                : Constants.Colors.white
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                viewModel.selectedLocations.contains(gym)
                                ? Constants.Colors.yellow
                                : Constants.Colors.gray02,
                                lineWidth: 1
                            )
                    }
                    .padding(.bottom, 12)
                    .onTapGesture {
                        withAnimation {
                            if viewModel.selectedLocations.contains(gym) {
                                viewModel.selectedLocations.removeAll { $0 == gym }
                            } else {
                                viewModel.selectedLocations.append(gym)
                            }
                            viewModel.checkForUnsavedChanges()
                        }
                    }
            }
        }
    }

    private var saveButton: some View {
        Button {
            viewModel.saveReminder()
        } label: {
            Text("Save Changes")
                .frame(width: 165, height: 41)
                .foregroundStyle(Constants.Colors.white)
                .font(Constants.Fonts.h3)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Constants.Colors.black)
                )
        }
    }
}

#Preview {
    CapacityRemindersView()
}
