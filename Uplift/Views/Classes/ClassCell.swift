//
//  ClassCell.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/27/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The cell representing a ClassInstance used in the classes page.
struct ClassCell: View {

    // MARK: - Properties

    let classInstance: FitnessClassInstance

    @ObservedObject var viewModel: ClassesView.ViewModel

    // MARK: - UI

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    startTimeText
                    durationText
                }
                .padding(.trailing, 24)

                VStack(alignment: .leading) {
                    classNameText
                    locationText

                    Spacer()

                    instructorText
                }

                Spacer()
            }
            .padding(16)
        }
        .frame(height: 100)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
    }

    private var startTimeText: some View {
        Text(viewModel.toDate(classInstance.startTime)?.formatted(date: .omitted, time: .shortened) ?? "")
            .font(Constants.Fonts.f3)
            .foregroundStyle(Constants.Colors.black)
    }

    private var durationText: some View {
        Text("\(viewModel.determineDuration(classInstance.startTime, classInstance.endTime) ?? "") min")
            .font(Constants.Fonts.labelNormal)
            .foregroundStyle(Constants.Colors.black)
    }

    private var classNameText: some View {
        Text(classInstance.fitnessClass?.name ?? "")
            .font(Constants.Fonts.f2)
            .foregroundStyle(Constants.Colors.black)
    }

    private var locationText: some View {
        Text(classInstance.location)
            .font(Constants.Fonts.labelLight)
            .foregroundStyle(Constants.Colors.black)
    }

    private var instructorText: some View {
        Text(classInstance.instructor)
            .font(Constants.Fonts.labelLight)
            .foregroundStyle(Constants.Colors.gray03)
    }

}
