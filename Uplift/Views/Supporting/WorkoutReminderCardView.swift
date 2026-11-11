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
                    withAnimation(.easeInOut(duration: Constants.Goals.animationDuration)) {
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
        VStack(spacing: Constants.WorkoutReminders.cardSpacing) {
            HStack {
                Text(reminder.daysText)
                    .foregroundStyle(reminder.isEnabled ? Constants.Colors.black : Constants.Colors.gray03)
                    .font(Constants.Fonts.reminder)
                    .padding(.vertical, Constants.WorkoutReminders.dayLabelVerticalPadding)
                    .padding(.horizontal, Constants.WorkoutReminders.dayLabelHorizontalPadding)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.WorkoutReminders.dayLabelCornerRadius)
                            .stroke(
                                Constants.Colors.gray01,
                                lineWidth: Constants.WorkoutReminders.dayLabelBorderWidth
                            )
                    )

                Spacer()

                // Existing toggle
            }

            HStack {
                Text(reminder.isAllDay ? "All-Day" : reminder.time)
                    .foregroundStyle(reminder.isEnabled ? Constants.Colors.black : Constants.Colors.gray03)
                    .font(Constants.Fonts.bodyBold)
                    .padding(.leading, Constants.WorkoutReminders.reminderTimeLeadingPadding)

                Spacer()
            }
        }
        .padding(Constants.WorkoutReminders.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.WorkoutReminders.cardCornerRadius)
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
