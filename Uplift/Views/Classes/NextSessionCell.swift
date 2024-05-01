//
//  NextSessionCell.swift
//  Uplift
//
//  Created by Caitlyn Jin on 4/28/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The cell representing a next session of a ClassInstance used in the classes page.
struct NextSessionCell: View {

    // MARK: - Properties

    let `class`: ClassInstance

    @ObservedObject var viewModel: ClassesView.ViewModel

    // MARK: - UI

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    dayText
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

    private var dayText: some View {
        Text(
            (viewModel.toDate(`class`.startTime)?.isSameDay(Date.now) ?? false
              ? "Today"
              : viewModel.toDate(`class`.startTime)?.getDayOfWeek().dayOfWeekShortened()) ?? ""
        )
            .font(Constants.Fonts.f3)
            .foregroundStyle(Constants.Colors.black)
    }

    private var durationText: some View {
        Text("\(viewModel.determineDuration(`class`.startTime, `class`.endTime) ?? "") min")
            .font(Constants.Fonts.labelNormal)
            .foregroundStyle(Constants.Colors.black)
    }

    private var classNameText: some View {
        Text(`class`.class?.name ?? "")
            .font(Constants.Fonts.f2)
            .foregroundStyle(Constants.Colors.black)
    }

    private var locationText: some View {
        Text(`class`.location)
            .font(Constants.Fonts.labelLight)
            .foregroundStyle(Constants.Colors.black)
    }

    private var instructorText: some View {
        Text(`class`.instructor)
            .font(Constants.Fonts.labelLight)
            .foregroundStyle(Constants.Colors.gray03)
    }

}
