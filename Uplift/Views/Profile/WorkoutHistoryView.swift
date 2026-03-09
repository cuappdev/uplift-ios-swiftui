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
    @Environment(\.dismiss) private var dismiss
    // TODO: Temporary bool since we don't have real data
    private var hasNoWorkouts = false

    var body: some View {
        ZStack {
            VStack {
                header
                content
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Constants.Images.arrowLeftLight
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(Constants.Colors.black)
                            .frame(width: 24, height: 24)
                    }
                }
            }

            if viewModel.selectedTab == .list && hasNoWorkouts {
                emptyState
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("History")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }
        }
        .padding(.bottom, 10)
        .background(Constants.Colors.lightGray)
        .frame(height: 96)
    }

    private var content: some View {
        VStack(spacing: 24) {
            SlidingTabBarView(
                config: SlidingTabBarView.TabBarConfig(),
                items: [
                    SlidingTabBarView.Item(
                        tab: WorkoutHistoryTab.calendar,
                        title: "Calendar",
                        icon: Constants.Images.calendarTab
                    ),
                    SlidingTabBarView.Item(
                        tab: WorkoutHistoryTab.list,
                        title: "List",
                        icon: Constants.Images.listTab
                    )
                ],
                selectedTab: $viewModel.selectedTab
            )

            switch viewModel.selectedTab {
            case .calendar:
                calendarView
            case .list:
                listView
            }

            Spacer()
        }
    }

    private var calendarView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                Button {
                    withAnimation {
                        viewModel.prevMonth()
                    }
                } label: {
                    Constants.Images.arrowSmall
                        .resizable()
                        .frame(width: 5, height: 9)
                        .foregroundColor(Constants.Colors.black)
                }

                Text("\(viewModel.currMonth.dateStringCalendarMonth)")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)

                Button {
                    withAnimation {
                        viewModel.nextMonth()
                    }
                } label: {
                    Constants.Images.arrowSmall
                        .resizable()
                        .frame(width: 5, height: 9)
                        .rotationEffect(.degrees(180))
                        .foregroundColor(Constants.Colors.black)
                }
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
        VStack(spacing: -0.5) {
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    Button {
                        withAnimation {
                            if viewModel.isSelected(week[index]) {
                                viewModel.selectedDay = nil
                            } else {
                                viewModel.selectedDay = week[index]
                            }
                        }
                    } label: {
                        VStack(spacing: 8) {
                            if let date = week[index] {
                                calendarDay(date)

                                Circle()
                                    .fill(date.isSameDay(Date.now) ? Constants.Colors.yellow : .clear)
                                    .frame(width: 8, height: 8)

                                selectedDayTriangleIndicator(date, week)
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .zIndex(1)

            if viewModel.weekHasSelectedDay(week) {
                selectedDayDropdown()
                    .zIndex(0)
            }
        }
    }

    private func calendarDay(_ date: Date) -> some View {
        Text("\(viewModel.calendar.component(.day, from: date))")
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.f3)
            .frame(width: 32, height: 32)
            .background {
                if date.isSameDay(Date.now) || viewModel.isSelected(date) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(date.isSameDay(Date.now) ? Constants.Colors.lightYellow : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Constants.Colors.yellow, lineWidth: 1)
                        )
                }
            }
    }

    private func selectedDayTriangleIndicator(_ date: Date, _ week: [Date?]) -> some View {
        VStack {
            if viewModel.isSelected(date) {
                Triangle()
                    .fill(Constants.Colors.lightYellow)
                    .frame(width: 18, height: 12)
                    .overlay(
                        TriangleTwoSideBorder()
                            .stroke(Constants.Colors.yellow, lineWidth: 0.8)
                            .frame(width: 18, height: 12)
                    )
            } else if viewModel.weekHasSelectedDay(week) {
                Color.clear
                    .frame(width: 18, height: 12)
            }
        }
    }

    private func selectedDayDropdown() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("Toni Morrison")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.f4)

                Spacer()
            }

            HStack {
                Text("6:30 PM ∙ Mar 2")
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.f4)

                Spacer()

                Text("Yesterday")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.f4)
            }
        }
        .padding(12)
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: viewModel.isSelectedDayOnLeft() ? 0 : 10,
                bottomLeadingRadius: 10,
                bottomTrailingRadius: 10,
                topTrailingRadius: viewModel.isSelectedDayOnRight() ? 0 : 10
            )
                .stroke(Constants.Colors.yellow, lineWidth: 1)
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: viewModel.isSelectedDayOnLeft() ? 0 : 10,
                        bottomLeadingRadius: 10,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: viewModel.isSelectedDayOnRight() ? 0 : 10
                    )
                        .fill(Constants.Colors.lightYellow)
                )
        }
        .padding(.horizontal, 16)
    }

    private var listView: some View {
        VStack {
            if !hasNoWorkouts {
                // TODO: Will have actual data later
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 0) {
                        if index == 0 {
                            HStack {
                                Text("March 2024")
                                    .foregroundStyle(Constants.Colors.black)
                                    .font(Constants.Fonts.h4)

                                Spacer()
                            }
                        }

                        historyListCell()

                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func historyListCell() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("Toni Morrison")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.f4)

                Spacer()
            }

            HStack {
                Text("Mar 2 ∙ 6:30 PM")
                    .foregroundStyle(Constants.Colors.gray04)
                    .font(Constants.Fonts.f4)

                Spacer()

                Text("Yesterday")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.f4)
            }
        }
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack {
            Spacer()

            VStack(spacing: 12) {
                Constants.Images.bag

                VStack(spacing: 4) {
                    Text("No workouts yet.")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h3)

                    Text("Head to a gym and check in!")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f3)
                }
            }

            Spacer()
        }
    }

}

enum WorkoutHistoryTab {
    case calendar
    case list
}

#Preview {
    WorkoutHistoryView()
}
