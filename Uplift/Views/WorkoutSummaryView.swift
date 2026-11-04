//
//  WorkoutSummaryView.swift
//  Uplift
//
//  Created by Kaylee Ulep on 10/28/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//
import SwiftUI

struct WorkoutSummaryView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = false

    @State private var title = "MEOW"
    @State private var description = ""
    @State private var satisfaction = 0.0

    //dummy
    private let location = "Helen Newman Hall"
    private let duration = "45 min 15 sec"
    private let date = "29 Mar 2024, 6:00pm - 6:45pm"

    private let satisfactionLabels = [
        "Off day",
        "Low",
        "Decent",
        "Good",
        "Great",
        "Excellent"
    ]

    private func informationRow(
        label: String,
        value: String
    ) -> some View {
        HStack(spacing: 4) {
            Text("\(label):")
                .foregroundStyle(Constants.Colors.gray04)

            Text(value)
                .foregroundStyle(Constants.Colors.black)
        }
        .font(Constants.Fonts.f2Regular)
    }

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
            .padding(.horizontal, Constants.WorkoutReminders.backButtonHorizontalPadding)
            .padding(.top, Constants.WorkoutReminders.backButtonTopPadding)
        }
        .background(Constants.Colors.white)

    }

    // title, location, duration, date, muscle group
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isEditing {
                workoutTitle
                    .padding(.bottom, 12)
            }

            informationRow(
                label: "Location",
                value: location
            )

            informationRow(
                label: "Duration",
                value: duration
            )

            informationRow(
                label: "Date",
                value: date
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var workoutTitle: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isEditing {
                Text("Workout Title")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.black)

                HStack(spacing: 8) {
                    TextField("Name your workout", text: $title)
                        .font(Constants.Fonts.f2Regular)
                        .frame(maxWidth: 200)

                    Constants.Images.pencil
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .padding(.bottom, 4)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Constants.Colors.gray02)
                        .frame(height: 1)
                }
            } else {
                Text(title.isEmpty ? "Workout Title" : title)
                    .font(Constants.Fonts.f2Regular)
                    .foregroundStyle(Constants.Colors.black)
            }
        }
    }

//    private var muscleGroup: some View {
//        
//    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isEditing ? "Description" : "Description:")
                .font(Constants.Fonts.f2Regular)
                .foregroundStyle(Constants.Colors.gray04)

            if isEditing {
                TextField(
                    "How did your workout go? Leave some notes here...",
                    text: $description,
                    axis: .vertical
                )
                .font(Constants.Fonts.bodyNormal)
                .foregroundStyle(Constants.Colors.black)
                .lineLimit(2...6)
            } else {
                Text(description.isEmpty
                     ? "How did your workout go? Leave some notes here..."
                     : description)
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(
                        description.isEmpty
                        ? Constants.Colors.gray03
                        : Constants.Colors.black
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 24)
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                informationSection
                    .padding(.bottom, 32)

                DividerLine()

                // muscleGroup
                // .padding(.bottom, 24)

                descriptionSection

                DividerLine()

                satisfactionSection
                .padding(.top, 32)

                actionButton
                    .padding(.top, 64)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }

    //would be nice to make a save button later
    private var actionButton: some View {
        Button {
            if isEditing {
                // TODO: Save workout
                isEditing = false
            } else {
                isEditing = true
            }
        } label: {
            HStack(spacing: 8) {
                if !isEditing {
                    Constants.Images.pencil
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Text(isEditing ? "Save" : "Edit")
                    .font(Constants.Fonts.h2)
            }
            .foregroundStyle(Constants.Colors.black)
            .frame(maxWidth: 253)
            .frame(height: 50)
            .background(Constants.Colors.yellow)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text(isEditing ? "Save Workout" : title)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)
                    .lineLimit(1)

                Spacer()
            }
        }
        .padding(.horizontal, 48)
        .padding(.bottom, Constants.WorkoutReminders.headerBottomPadding)
        .background(Constants.Colors.lightGray)
        .frame(height: Constants.WorkoutReminders.headerHeight)
    }

    private var satisfactionSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(isEditing
                 ? "How satisfied were you with today’s workout?"
                 : "Rating:")
                .font(Constants.Fonts.f2Regular)
                .foregroundStyle(Constants.Colors.gray04)

            Slider(
                value: $satisfaction,
                in: 0...5,
                step: 1
            )
            .tint(Constants.Colors.yellow)
            .disabled(!isEditing)

            HStack(spacing: 0) {
                ForEach(0..<6, id: \.self) { index in
                    VStack(spacing: 8) {
                        Text("\(index)")
                            .font(Constants.Fonts.bodySemibold)
                            .foregroundStyle(Constants.Colors.gray05)

                        Text(satisfactionLabels[index])
                            .font(Constants.Fonts.labelLight)
                            .foregroundStyle(Constants.Colors.gray05)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

}

#Preview {
    WorkoutSummaryView()
}
