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
    @State private var description = ""
    @State private var issueIsExpanded = true
    @State private var gymIsExpanded = true
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
                    NavBackButton(color: Constants.Colors.black, dismiss: dismiss)
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
                isExpanded: $issueIsExpanded,
                options: [
                    "Inaccurate equipment",
                    "Incorrect hours",
                    "Inaccurate description",
                    "Wait time not updated",
                    "Other"
                ],
                selectedOption: $selectedIssue
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
                isExpanded: $gymIsExpanded,
                options: [
                    "Morrison",
                    "Teagle",
                    "Helen Newman",
                    "Noyes",
                    "Other"
                ],
                selectedOption: $selectedGym
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
        NavigationLink {
            ReportSuccessView()
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

#Preview {
    ReportView()
}
