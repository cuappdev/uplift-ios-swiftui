//
//  WorkoutHistoryView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/25/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        calendarTab
        Spacer()
    }

    private var calendarTab: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                Constants.Images.arrowSmall
                    .resizable()
                    .frame(width: 5, height: 9)
                    .foregroundColor(Constants.Colors.black)

                Text("Mar 2024")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)

                Constants.Images.arrowSmall
                    .resizable()
                    .frame(width: 5, height: 9)
                    .rotationEffect(.degrees(180))
                    .foregroundColor(Constants.Colors.black)
            }

            HStack {
                ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                    Text(day.dayOfWeekAbbreviation())
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h3)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            VStack(spacing: 24) {
                ForEach(viewModel.weeksInMonth, id: \.self) { week in
                    weekView(week)
                }
            }
        }
    }

    private func weekView(_ week: [Date?]) -> some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                VStack(spacing: 8) {
                    if let date = week[index] {
                        Text("\(viewModel.calendar.component(.day, from: date))")
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.f3)
                            .frame(width: 32, height: 32)
                            .background {
                                if date.isSameDay(Date.now) {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Constants.Colors.lightYellow)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Constants.Colors.yellow, lineWidth: 1)
                                        )
                                }
                            }

                            Circle()
                                .fill(date.isSameDay(Date.now) ? Constants.Colors.yellow : .clear)
                                .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

}

#Preview {
    WorkoutHistoryView()
}
