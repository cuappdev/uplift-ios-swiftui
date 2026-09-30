//
//  AboutView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 3/22/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSemester = allSemesters
    @State private var semesterIsExpanded = false

    private static let allSemesters = "All Semesters"

    var body: some View {
        VStack {
            header
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) {
            backButton
        }

    }

    private var backButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Constants.Images.arrowLeft
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Constants.Colors.black)
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("About Uplift")
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
            VStack(alignment: .center) {
                Image("appdev_rocket")
                    .padding(.top, 32)

                Text("Designed and developed by:")
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.center)
                    .font(Constants.Fonts.labelNormal)
                    .padding(.top, 8)

                Text("CornellAppDev")
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.center)
                    .font(Constants.Fonts.h1)
                    .padding(.top, 8)

                semesterSection

                ForEach(visibleSemesters, id: \.self) { semester in
                    MembersGridView(title: semester.rawValue, members: semester.members)
                }
            }
            .padding(.bottom, 32)
        }
    }

    private var semesterSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Semester")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }

            Dropdown(
                displayError: .constant(false),
                isExpanded: $semesterIsExpanded,
                selectedOption: $selectedSemester,
                options: [Self.allSemesters] + Semester.allCases.map(\.rawValue)
            )
        }
        .padding(.horizontal, Constants.Padding.reportHorizontal)
        .padding(.top, 24)
    }

    private var visibleSemesters: [Semester] {
        Semester.allCases.filter { selectedSemester == Self.allSemesters || $0.rawValue == selectedSemester }
    }
}
#Preview {
    AboutView()
}
