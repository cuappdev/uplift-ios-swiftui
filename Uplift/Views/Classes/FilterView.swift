//
//  FilterView.swift
//  Uplift
//
//  Created by Sandy Yang on 9/30/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FilterView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Binding var filter: ClassFilter

    // Placeholder data, will connect from view model later
    private let fitnessCenters = ["Noyes", "Helen Newman", "Teagle", "Appel"]
    private let classTypes = ["Spinning", "Barre", "H.I.I.T."]
    private let instructors = ["Emily", "Lauren", "Mia"]

    // MARK: - UI

    var body: some View {
        VStack {
            topBar
            ScrollView {
                VStack {
                    fitnessCenterSection
                    DividerLine()
                    startTimeSection
                    DividerLine()
                    dropdownSection()
                    DividerLine()
                    dropdownSection()
                    DividerLine()
                }
            }
        }
        .background(Constants.Colors.white)
    }

    private var topBar: some View {
        HStack {
            Button("Reset") { filter = .default }
            Spacer()
            Text("Refine Search")
                .font(Constants.Fonts.h3)
            Spacer()
            Button("Done") { dismiss() }
        }
        .foregroundStyle(Constants.Colors.black)
        .padding(.top, 46)
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .background(Constants.Colors.gray01)
    }

    private var fitnessCenterSection: some View {
        VStack {
            Text("FITNESS CENTER")
                .font(Constants.Fonts.h4)
                .foregroundStyle(Constants.Colors.gray04)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }

    private var startTimeSection: some View {
        VStack {
            HStack {
                Text("START TIME")
                Spacer()
                Text("\(formatted(filter.startHour)) - \(formatted(filter.endHour))")
            }
            .font(Constants.Fonts.h4)
            .foregroundStyle(Constants.Colors.gray04)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }

    private func dropdownSection() -> some View {
        Text("dropdown")
    }

    // MARK: - Helpers

    private func formatted(_ hour: Double) -> String {
        let h = Int(hour)
        let m = Int((hour - Double(h)) * 60)
        let display = h % 12 == 0 ? 12 : h % 12
        return String(format: "%d:%02d %@", display, m, h >= 12 ? "PM" : "AM")
    }
}

#Preview {
    FilterView(filter: .constant(ClassFilter()))
}
