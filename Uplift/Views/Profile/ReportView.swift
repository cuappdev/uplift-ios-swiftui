//
//  ReportView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/16/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The view for reporting an issue.
struct ReportView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Binding var isActive: Bool
    @Binding var profileIsActive: Bool
    @Binding var reportSuccessIsActive: Bool
    @State private var description = ""
    @State private var displayGymError = false
    @State private var displayIssueError = false
    @State private var gymIsExpanded = true
    @State private var issueIsExpanded = true
    @State private var selectedGym = ""
    @State private var selectedIssue = ""

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
                    Button {
                        withAnimation(.easeIn(duration: 0.3)) {
                            profileIsActive.toggle()
                            isActive.toggle()
                        }
                    } label: {
                        Constants.Images.arrowLeft
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

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Report an issue")
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
            VStack(spacing: 24) {
                issueSection
                gymSection
                describeSection

                Spacer()

                submitButton

                Spacer()
            }
            .padding(EdgeInsets(
                top: Constants.Padding.reportVertical,
                leading: Constants.Padding.reportHorizontal,
                bottom: Constants.Padding.reportVertical,
                trailing: Constants.Padding.reportHorizontal
            ))
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var issueSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("What was the issue?")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }

            Dropdown(
                displayError: $displayIssueError,
                isExpanded: $issueIsExpanded,
                selectedOption: $selectedIssue,
                options: [
                    "Inaccurate equipment",
                    "Incorrect hours",
                    "Inaccurate description",
                    "Wait time not updated",
                    "Other"
                ]
            )
        }
    }

    private var gymSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Which gym does this concern?")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }

            Dropdown(
                displayError: $displayGymError,
                isExpanded: $gymIsExpanded,
                selectedOption: $selectedGym,
                options: [
                    "Morrison",
                    "Teagle",
                    "Helen Newman",
                    "Noyes",
                    "Other"
                ]
            )
        }
    }

    private var describeSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Describe what's wrong for us.")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }

            TextField(
                "",
                text: $description,
                prompt: Text("What happened?")
                    .foregroundColor(Constants.Colors.gray04)
                    .font(Constants.Fonts.f3),
                axis: .vertical
            )
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.f3)
            .lineLimit(10...)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Constants.Colors.gray01)
            )
        }
    }

    private var submitButton: some View {
        Button {
            if !selectedIssue.isEmpty && !selectedGym.isEmpty {
                withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
                    isActive.toggle()
                }
                withAnimation(.easeIn(duration: 0.3)) {
                    reportSuccessIsActive.toggle()
                }
            } else {
                displayIssueError = selectedIssue.isEmpty
                displayGymError = selectedGym.isEmpty
            }
        } label: {
            VStack {
                Text("SUBMIT")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
            }
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .background(
                RoundedRectangle(cornerRadius: 36)
                    .foregroundStyle(Constants.Colors.yellow)
            )
            .upliftShadow(Constants.Shadows.smallLight)
        }
    }
}
