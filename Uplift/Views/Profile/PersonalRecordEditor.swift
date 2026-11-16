//
//  PersonalRecordEditor.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PersonalRecordEditor: View {

    // MARK: - Types

    struct Request: Identifiable {
        let id = UUID()
        let lift: String
    }

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
        VStack(spacing: 0) {
            header

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Constants.PersonalRecords.editorSpacing) {
                    liftSection
                    DividerLine()
                    weightSection
                    repsSection
                }
                .padding(.horizontal, Constants.Padding.homeHorizontal)
                .padding(.vertical, Constants.PersonalRecords.editorSpacing)
            }

            saveButton
        }
        .background(Constants.Colors.white)
    }

    private var header: some View {
        ZStack {
            Text("Log a PR")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Constants.Images.chevronDown
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: Constants.PushedScreen.backButtonSize,
                            height: Constants.PushedScreen.backButtonSize
                        )
                        .foregroundStyle(Constants.Colors.black)
                }

                Spacer()
            }
        }
        .padding(.horizontal, Constants.Padding.homeHorizontal)
        .padding(.vertical, Constants.PersonalRecords.headerPadding)
        .overlay(alignment: .bottom) {
            DividerLine()
        }
    }

    private var liftSection: some View {
        VStack(alignment: .leading, spacing: Constants.PersonalRecords.fieldSpacing) {
            label("Lift")
            underlined(TextField("Name your lift", text: $lift))
            suggestions
        }
    }

    private var suggestions: some View {
        FlowLayout(spacing: Constants.PersonalRecords.chipSpacing) {
            ForEach(Constants.PersonalRecords.suggestedLifts, id: \.self) { suggestion in
                Button {
                    lift = suggestion
                } label: {
                    Text(suggestion)
                        .font(Constants.Fonts.bodyMedium)
                        .foregroundStyle(Constants.Colors.black)
                        .padding(.horizontal, Constants.PersonalRecords.chipHorizontalPadding)
                        .padding(.vertical, Constants.PersonalRecords.chipVerticalPadding)
                        .background(lift == suggestion ? Constants.Colors.yellow : Constants.Colors.white)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.PersonalRecords.chipCornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.PersonalRecords.chipCornerRadius)
                                .stroke(Constants.Colors.gray04, lineWidth: 1)
                        )
                }
            }
        }
    }

    private var weightSection: some View {
        VStack(alignment: .leading, spacing: Constants.PersonalRecords.fieldSpacing) {
            label("Weight")
            underlined(
                HStack {
                    TextField("0", text: $weightText)
                        .keyboardType(.decimalPad)

                    Text("lb")
                        .foregroundStyle(Constants.Colors.gray04)
                }
            )
        }
    }

    private var repsSection: some View {
        HStack {
            label("Reps")

            Spacer()

            stepButton("minus") {
                reps = max(1, reps - 1)
            }

            Text("\(reps)")
                .font(Constants.Fonts.h2)
                .monospacedDigit()
                .frame(minWidth: Constants.PersonalRecords.repsWidth)

            stepButton("plus") {
                reps += 1
            }
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
                .frame(width: Constants.PersonalRecords.saveWidth)
                .padding(.vertical, Constants.PersonalRecords.saveVerticalPadding)
                .background(canSave ? Constants.Colors.yellow : Constants.Colors.gray01)
                .clipShape(Capsule())
                .shadow(color: Constants.Colors.black.opacity(0.15), radius: 4, y: 2)
        }
        .disabled(!canSave)
        .padding(.bottom, Constants.PersonalRecords.editorSpacing)
    }

    // MARK: - Supporting

    private func label(_ text: String) -> some View {
        Text(text)
            .font(Constants.Fonts.f2Regular)
            .foregroundStyle(Constants.Colors.gray04)
    }

    private func underlined<Content: View>(_ content: Content) -> some View {
        content
            .font(Constants.Fonts.f2Regular)
            .padding(.bottom, 4)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Constants.Colors.gray02)
                    .frame(height: 1)
            }
    }

    private func stepButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .frame(width: Constants.PersonalRecords.stepSize, height: Constants.PersonalRecords.stepSize)
                .overlay(Circle().stroke(Constants.Colors.gray04, lineWidth: 1))
        }
    }

}
