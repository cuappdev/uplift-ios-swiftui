//
//  CapacityRemindersView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 9/26/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import WrappingHStack
import FirebaseMessaging

/// The view for the Capacity Reminders page.
struct CapacityRemindersView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showInfo = false
    @State private var fcmToken: String = ""

    @State private var showUnsavedChangesModal = false
    @State private var hasUnsavedChanges: Bool = false

    @State private var originalSelectedDays: [DayOfWeek] = []
    @State private var originalCapacityThreshold: Double = 50
    @State private var originalSelectedLocations: [String] = []
    @State private var originalShowInfo: Bool = false

    private let gyms = ["TEAGLEUP", "TEAGLEDOWN", "HELENNEWMAN", "TONIMORRISON", "NOYES"]

    init() {
        if let savedId = UserDefaults.standard.object(forKey: "savedReminderId") as? Int {
            _viewModel = StateObject(wrappedValue: ViewModel(savedReminderId: savedId))
            _showInfo = State(initialValue: true)
            _originalShowInfo = State(initialValue: true)
        }
    }

    /// checks for unsaved changes
    private func checkForUnsavedChanges() {
        hasUnsavedChanges = (
            showInfo != originalShowInfo ||
            viewModel.selectedDays != originalSelectedDays ||
            viewModel.capacityThreshold != originalCapacityThreshold ||
            viewModel.selectedLocations != originalSelectedLocations
        )
    }

    /// saves original values when needed
    private func saveOriginalValues() {
        originalSelectedDays = viewModel.selectedDays
        originalCapacityThreshold = viewModel.capacityThreshold
        originalSelectedLocations = viewModel.selectedLocations
        originalShowInfo = showInfo
    }

    /// retrieves the FCM token
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error getting FCM token: \(error.localizedDescription)")
            } else if let token = token {
                print("FCM TOKEN: \(token)")
                self.fcmToken = token
                UIPasteboard.general.string = token
            }
        }
    }

    /// custom back button logic now that we have custom unsaved logic
    private func handleBackButton() {
        checkForUnsavedChanges()
        if hasUnsavedChanges {
            showUnsavedChangesModal = true
        } else {
            dismiss()
        }
    }

    /// creates a default reminder if toggle is on; if off, deletes it from the local storage
    private func handleToggleChange(isOn: Bool) {
        if isOn {
            if viewModel.savedReminderId == nil {
                createDefaultReminder()
            }
        } else {
            if viewModel.savedReminderId != nil {
                viewModel.deleteCapacityReminder()
            }
        }
        checkForUnsavedChanges()
    }

    /// creates a default reminder
    private func createDefaultReminder() {
        let daysOfWeekStrings = viewModel.selectedDays.map { $0.dayOfWeekComplete().uppercased() }

        viewModel.createCapacityReminder(
            capacityPercent: Int(viewModel.capacityThreshold),
            daysOfWeek: daysOfWeekStrings,
            fcmToken: fcmToken,
            gyms: viewModel.selectedLocations
        )
    }

    /// edits the device's reminder
    private func saveReminder() {
        if viewModel.savedReminderId != nil {
            let daysOfWeekStrings = viewModel.selectedDays.map { $0.dayOfWeekComplete().uppercased() }

            viewModel.editCapacityReminder(
                capacityPercent: Int(viewModel.capacityThreshold),
                daysOfWeek: daysOfWeekStrings,
                gyms: viewModel.selectedLocations
            )
        }

        saveOriginalValues()
        hasUnsavedChanges = false
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
                    Button(action: handleBackButton) {
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
                getFCMToken()
                saveOriginalValues()
            }
            .overlay(
                Group {
                    if showUnsavedChangesModal {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showUnsavedChangesModal = false
                                    }
                                }

                            UnsavedChangesModal(
                                onSaveChanges: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        saveReminder()
                                        showUnsavedChangesModal = false
                                        dismiss()
                                    }
                                },
                                onContinue: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showInfo = originalShowInfo
                                        viewModel.selectedDays = originalSelectedDays
                                        viewModel.capacityThreshold = originalCapacityThreshold
                                        viewModel.selectedLocations = originalSelectedLocations
                                        hasUnsavedChanges = false
                                        showUnsavedChangesModal = false
                                        dismiss()
                                    }
                                },
                                onCancel: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showUnsavedChangesModal = false
                                    }
                                }
                            )
                            .transition(.opacity)
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: showUnsavedChangesModal)
            )
        }
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

                    Toggle("", isOn: $showInfo.animation())
                        .tint(Constants.Colors.yellow)
                        .onChange(of: showInfo) { newValue in
                            handleToggleChange(isOn: newValue)
                        }
                }

                Text("Uplift will send you a notification when gyms dip below the set capacity")
                    .foregroundStyle(Constants.Colors.gray03)
                    .font(Constants.Fonts.labelNormal)
                    .multilineTextAlignment(.leading)
            }

            showInfo ? reminderInfo : nil

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
                                checkForUnsavedChanges()
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
                    checkForUnsavedChanges()
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
                            checkForUnsavedChanges()
                        }
                    }
            }
        }
    }

    private var saveButton: some View {
        Button {
            saveReminder()
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
