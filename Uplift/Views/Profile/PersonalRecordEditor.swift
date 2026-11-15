//
//  PersonalRecordEditor.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PersonalRecordEditor: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PersonalRecordsView.ViewModel

    @State var lift: String
    @State private var reps = 1
    @State private var weightText = ""

    private var weight: Double? {
        Double(weightText)
    }

    private var canSave: Bool {
        !lift.trimmingCharacters(in: .whitespaces).isEmpty && (weight ?? 0) > 0
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.PersonalRecords.editorSpacing) {
            Text("Log a PR")
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.black)

            liftField
            suggestions

            HStack(spacing: Constants.PersonalRecords.editorSpacing) {
                weightField
                repsStepper
            }

            Spacer(minLength: 0)

            saveButton
        }
        .padding(Constants.Padding.homeHorizontal)
        .padding(.top, Constants.PersonalRecords.editorTopPadding)
        .presentationDetents([.medium])
    }

    private var liftField: some View {
        TextField("Lift", text: $lift)
            .font(Constants.Fonts.f2)
            .padding(Constants.Friends.searchPadding)
            .background(Constants.Colors.gray00)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Friends.searchCornerRadius))
    }

    private var suggestions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Constants.PersonalRecords.suggestedLifts, id: \.self) { suggestion in
                    Button(suggestion) {
                        lift = suggestion
                    }
                    .font(Constants.Fonts.labelSemibold)
                    .foregroundStyle(Constants.Colors.black)
                    .padding(.horizontal, Constants.Friends.buttonHorizontalPadding)
                    .padding(.vertical, Constants.Friends.buttonVerticalPadding)
                    .background(lift == suggestion ? Constants.Colors.yellow : Constants.Colors.gray00)
                    .clipShape(Capsule())
                }
            }
        }
    }

    private var weightField: some View {
        HStack {
            TextField("Weight", text: $weightText)
                .keyboardType(.decimalPad)
                .font(Constants.Fonts.f2)

            Text("lb")
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.gray04)
        }
        .padding(Constants.Friends.searchPadding)
        .background(Constants.Colors.gray00)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Friends.searchCornerRadius))
    }

    private var repsStepper: some View {
        HStack(spacing: 12) {
            stepButton("minus") {
                reps = max(1, reps - 1)
            }

            Text("\(reps) rep\(reps == 1 ? "" : "s")")
                .font(Constants.Fonts.f2)
                .monospacedDigit()
                .frame(minWidth: Constants.PersonalRecords.repsWidth)

            stepButton("plus") {
                reps += 1
            }
        }
    }

    private func stepButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .frame(width: Constants.PersonalRecords.stepSize, height: Constants.PersonalRecords.stepSize)
                .background(Constants.Colors.gray00)
                .clipShape(Circle())
        }
    }

    private var saveButton: some View {
        Button {
            guard let weight else { return }
            viewModel.log(lift: lift, weight: weight, reps: reps)
            dismiss()
        } label: {
            Text("Save")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Constants.PersonalRecords.saveVerticalPadding)
                .background(canSave ? Constants.Colors.yellow : Constants.Colors.gray01)
                .clipShape(Capsule())
        }
        .disabled(!canSave)
    }

}
