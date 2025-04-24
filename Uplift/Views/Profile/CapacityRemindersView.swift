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
    @State private var capacity = 50.0
    @State private var showInfo = false
    @State private var fcmToken: String = ""

    // MARK: - Constants

    private let gyms = ["TEAGLEUP", "TEAGLEDOWN", "HELENNEWMAN", "TONIMORRISON", "NOYES"]

    // MARK: - Init

    init() {
        if let savedId = UserDefaults.standard.object(forKey: "savedReminderId") as? Int {
            _viewModel = StateObject(wrappedValue: ViewModel(savedReminderId: savedId))
            _showInfo = State(initialValue: true)
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
                    NavBackButton(color: Constants.Colors.black, dismiss: dismiss)
                }
            }
            .background(Constants.Colors.white)
            .onAppear {
                getFCMToken()
            }
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
                        Text("\(Int(capacity))%")
                            .foregroundStyle(Constants.Colors.gray04)
                            .font(Constants.Fonts.bodySemibold)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Constants.Colors.gray00)
                            }
                            .position(x: capacity / 99 * (geometry.size.width - 32) + 16)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 12)

                Slider(
                    value: $capacity,
                    in: 0...100,
                    step: 10
                )
                .tint(Constants.Colors.yellow)
                .frame(height: 8)

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
                        }
                    }
            }
        }
    }

    private var saveButton: some View {
        Button {
            saveReminder()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 14, weight: .bold))

                Text("Save")
                    .font(Constants.Fonts.h2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Constants.Colors.yellow)
            )
            .foregroundColor(.black)
        }
        .disabled(viewModel.creatingReminder
                  || viewModel.editingReminder
                  || viewModel.selectedDays.isEmpty
                  || viewModel.selectedLocations.isEmpty)
        .opacity((viewModel.creatingReminder
                  || viewModel.editingReminder
                  || viewModel.selectedDays.isEmpty
                  || viewModel.selectedLocations.isEmpty) ? 0.5 : 1)
    }

    // MARK: - Helper methods

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

    private func handleToggleChange(isOn: Bool) {
        if isOn {
            if viewModel.savedReminderId == nil {
                createDefaultReminder()
            }
        } else {
            if let _ = viewModel.savedReminderId {
                viewModel.deleteCapacityReminder()
                UserDefaults.standard.removeObject(forKey: "savedReminderId")
            }
        }
    }

    private func createDefaultReminder() {
        let daysOfWeekStrings = viewModel.selectedDays.map { $0.dayOfWeekComplete().uppercased() }

        viewModel.createCapacityReminder(
            capacityPercent: Int(capacity),
            daysOfWeek: daysOfWeekStrings,
            fcmToken: fcmToken,
            gyms: viewModel.selectedLocations
        )
    }

    private func saveReminder() {
        if let _ = viewModel.savedReminderId {
            let daysOfWeekStrings = viewModel.selectedDays.map { $0.dayOfWeekComplete().uppercased() }

            viewModel.editCapacityReminder(
                capacityPercent: Int(capacity),
                daysOfWeek: daysOfWeekStrings,
                gyms: viewModel.selectedLocations
            )
        }
    }
}

#Preview {
    CapacityRemindersView()
}
