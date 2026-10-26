//
//  WorkoutReminderCardView.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/23/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing a workout reminder.
struct WorkoutReminderCardView: View {

    // MARK: - Properties

    @Binding var editingReminder: WorkoutReminder?

    let reminder: WorkoutReminder
    let onToggle: (Bool) -> Void
    let onUpdate: (WorkoutReminder) -> Void
    let onDelete: () -> Void

    private var isEditing: Binding<Bool> {
        Binding(
            get: {
                editingReminder?.id == reminder.id
            },
            set: { newValue in
                if !newValue {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        editingReminder = nil
                    }
                }
            }
        )
    }

    // MARK: - UI

    var body: some View {
        if isEditing.wrappedValue {
            WorkoutReminderEditView(
                inEditMode: isEditing,
                isNew: false,
                onUpdate: onUpdate,
                onDelete: onDelete,
                reminder: reminder
            )
        } else {
            displayReminder
        }
    }

    private var displayReminder: some View {
        VStack(spacing: 16) {
            HStack {
                Text(reminder.daysText)
                    .foregroundStyle(reminder.isEnabled ? Constants.Colors.black : Constants.Colors.gray03)
                    .font(Constants.Fonts.reminder)
                    .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Constants.Colors.gray01, lineWidth: 1)
                    )

                Spacer()

                Toggle(
                    "",
                    isOn: Binding(
                        get: { reminder.isEnabled },
                        set: { onToggle($0) }
                    ).animation()
                )
                .tint(Constants.Colors.yellow)
                .labelsHidden()
            }

            HStack {
                Text(reminder.isAllDay ? "All-Day" : reminder.time)
                    .foregroundStyle(reminder.isEnabled ? Constants.Colors.black : Constants.Colors.gray03)
                    .font(Constants.Fonts.bodyBold)
                    .padding(.leading, 16)

                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Constants.Colors.white)
        )
        .upliftShadow(Constants.Shadows.smallLight)
        .onTapGesture {
            withAnimation(.easeInOut(duration: Constants.Goals.animationDuration)) {
                editingReminder = reminder
            }
        }
    }

}
