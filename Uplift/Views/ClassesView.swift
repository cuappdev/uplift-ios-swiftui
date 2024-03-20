//
//  ClassesView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/6/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The main view for the Classes page.
struct ClassesView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            header
            scrollContent
        }
        .background(Constants.Colors.white)
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Text("Classes")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h1)

                Spacer()
            }
        }
        .padding(
            EdgeInsets(
                top: 0,
                leading: Constants.Padding.homeHorizontal,
                bottom: 12,
                trailing: Constants.Padding.homeHorizontal
            )
        )
        .background(
            Constants.Colors.white
                .upliftShadow(Constants.Shadows.smallLight)
        )
        .ignoresSafeArea(.all)
        .frame(height: 64)
    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                weekCalendar
            }
        }
    }

    private var weekCalendar: some View {
        HStack(spacing: 30) {
            ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                VStack {
                    Text(day.dayOfWeekAbbreviation())

                    Text(viewModel.determineDayOfMonth(weekday: day))
                        .frame(width: 24, height: 24)
                        .background {
                            if Date.now.getDayOfWeek() == day || viewModel.selectedDay == day {
                                Circle()
                                    .fill(
                                        viewModel.selectedDay == day ? Constants.Colors.yellow : Constants.Colors.gray01
                                    )
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectedDay = day
                            }
                        }
                }
                .foregroundStyle(
                    viewModel.selectedDay == day ? Constants.Colors.black : Constants.Colors.gray02
                )
            }

        }
        .font(Constants.Fonts.h4)
        .foregroundStyle(Constants.Colors.black)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

#Preview {
    ClassesView()
}
