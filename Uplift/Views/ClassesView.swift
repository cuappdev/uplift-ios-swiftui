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
    @State private var weeks: [Int] = [0, 1, 2]     // Integers represent the number of weeks from the current week

    // MARK: - UI

    var body: some View {
        NavigationStack {
            VStack {
                header
                scrollContent
            }
            .background(Constants.Colors.white)
        }
        .onAppear {
            viewModel.fetchAllClasses()
        }
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
            LazyVStack {
                calendarView
                classesOnDay
            }
            .padding(.bottom, 32)
        }
        .refreshable {
            viewModel.refreshClasses()
        }
    }

    private var calendarView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(weeks, id: \.self) { week in
                        HStack(spacing: 30) {
                            ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                                calendarDay(day, week)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .font(Constants.Fonts.h4)
                        .foregroundStyle(Constants.Colors.black)
                        .id(week)   // Used for drag gesture
                    }
                }
                .frame(minHeight: 58)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .scrollDisabled(true)
            .highPriorityGesture(
                DragGesture().onEnded { value in
                    if value.translation.width < -1 {
                        withAnimation {
                            proxy.scrollTo(viewModel.weeksFromCurr + 1)
                        }
                        viewModel.weeksFromCurr += 1 // Adjust to current week

                        if viewModel.weeksFromCurr == weeks.count - 1 {
                            weeks.append(viewModel.weeksFromCurr + 1) // Create a new week
                        }
                    } else if value.translation.width > 1 {
                        if viewModel.weeksFromCurr > 0 {
                            withAnimation {
                                proxy.scrollTo(viewModel.weeksFromCurr - 1)
                            }
                            viewModel.weeksFromCurr -= 1 // Adjust to current week
                        }
                    }
                }
            )
        }
    }

    private func calendarDay(_ day: DayOfWeek, _ week: Int) -> some View {
        VStack(spacing: 4) {
            VStack {
                if viewModel.hasClasses(weekday: day) {
                    Circle()
                        .fill(Constants.Colors.yellow)
                }
            }
            .frame(width: 8, height: 8)

            Text(day.dayOfWeekAbbreviation())
                .padding(.bottom, 2)

            Text(viewModel.determineDayOfMonth(day, week)?.formatted(.dateTime.day()) ?? "")
                .frame(width: 24, height: 24)
                .background {
                    if (Date.now.getDayOfWeek() == day && week == 0) || viewModel.selectedDay == day {
                        Circle()
                            .fill(
                                viewModel.selectedDay == day ? Constants.Colors.yellow : Constants.Colors.gray01
                            )
                    }
                }
        }
        .foregroundStyle(
            viewModel.selectedDay == day ? Constants.Colors.black : Constants.Colors.gray02
        )
        .onTapGesture {
            withAnimation {
                viewModel.selectedDay = day
            }
        }
    }

    private var classesOnDay: some View {
        VStack(spacing: 28) {
            Text(viewModel.selectedDay == Date.now.getDayOfWeek() && viewModel.weeksFromCurr == 0
                 ? "TODAY"
                 : viewModel.selectedDay.dayOfWeekComplete().uppercased())
                .font(Constants.Fonts.h2)

            VStack(spacing: 12) {
                if viewModel.classes == nil {
                    ForEach(0..<5) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Constants.Colors.gray01)
                            .frame(height: 100)
                            .shimmer(.medium)
                    }
                } else {
                    if viewModel.filteredClasses.isEmpty {
                        Spacer()

                        VStack {
                            Constants.Images.greenTea
                                .padding(24)

                            Text("No classes today")
                                .font(Constants.Fonts.h1)
                                .foregroundStyle(Constants.Colors.black)

                            Text("Relax with some tea or play a sport")
                                .font(Constants.Fonts.bodyNormal)
                                .foregroundStyle(Constants.Colors.black)
                        }
                    } else {
                        ForEach(viewModel.filteredClasses, id: \.self) { classInstance in
                            NavigationLink {
                                ClassDetailView(classInstance: classInstance, viewModel: viewModel)
                            } label: {
                                ClassCell(classInstance: classInstance, viewModel: viewModel)
                            }
                            .contentShape(Rectangle()) // Fixes navigation link tap area
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ClassesView()
}
