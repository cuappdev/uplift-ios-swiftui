//
//  ProfileView.swift
//  Uplift
//
//  Created by jiwon jeong on 2/27/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//
import SwiftUI
import Kingfisher

/// The main view for the Profile page.
struct ProfileView: View {

    // MARK: - Properties
    @EnvironmentObject var tabBarProp: TabBarProperty
    @StateObject private var viewModel = ViewModel()

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
            viewModel.fetchUserProfile()
        }
    }

    private var header: some View {
        VStack {
            Spacer()
            HStack {
                Text("Profile")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h1)
                Spacer()
                settingsButton
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

    private var settingsButton: some View {
        Button {
            viewModel.showSettingsSheet = true
        } label: {
            Image(systemName: "gearshape.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Constants.Colors.black)
        }
        .sheet(isPresented: $viewModel.showSettingsSheet) {
            settingsView
        }
    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                Spacer()
                profileTopSection
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.bottom, 32 + Constants.Padding.tabBarHeight)
        }
        .refreshable {
            viewModel.fetchUserProfile()
        }
    }

    private var profileTopSection: some View {
        HStack(spacing: 24) {
                // Profile image with camera icon
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 98, height: 98)
                        .foregroundStyle(Constants.Colors.gray02)

                    // Camera button overlay
                    Circle()
                        .fill(Constants.Colors.white)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Constants.Colors.gray03)
                        )
                        .offset(x: 2, y: 2)
                }

                // Name and workouts count
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.profile?.name ?? "Yucheng Shu")
                        .font(Constants.Fonts.h1)
                        .foregroundStyle(Constants.Colors.black)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Workouts")
                                .font(Constants.Fonts.bodyLight)
                                .foregroundStyle(Constants.Colors.gray03)

                            Text("\(viewModel.totalWorkouts)")
                                .font(Constants.Fonts.h2)
                                .foregroundStyle(Constants.Colors.black)
                        }
                        Spacer()

                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(viewModel.isFavorited ? Constants.Colors.yellow : Constants.Colors.gray02)

                                Text("Favorites")
                                    .font(Constants.Fonts.bodyLight)
                                    .foregroundStyle(Constants.Colors.black)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Constants.Colors.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Constants.Colors.gray01, lineWidth: 1)
                            )
                        }
                    }
                }
        }
    }

    private var settingsView: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Settings")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Button {
                    viewModel.showSettingsSheet = false
                } label: {
                    Constants.Images.cross
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.black)
                }
            }
            .padding(.top, 24)
            DividerLine()
            Button {

            } label: {
                HStack {
                    Text("About Uplift")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {

            } label: {
                HStack {
                    Text("Reminders")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {
            } label: {
                HStack {
                    Text("Report an Issue")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {

            } label: {
                Text("Log Out")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.closed)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Constants.Colors.white)
    }
}

// **MARK: - ViewModel**
extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var profile: UserProfile?
        @Published var showSettingsSheet = false
        @Published var workoutHistory: [WorkoutHistory] = []
        @Published var weeklyWorkouts: WeeklyWorkoutData = WeeklyWorkoutData(
            currentWeekWorkouts: 0,
            weeklyGoal: 5,
            weekDates: []
        )
        @Published var totalWorkouts: Int = 0
        @Published var isFavorited: Bool = false

        func fetchUserProfile() {
            // Simulate network fetch with mock data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.profile = UserProfile(
                    id: "user123",
                    name: "Jiwon Jeong"
                )

                self.totalWorkouts = 132
                self.isFavorited = false

                // Create dates for the week
                let weekDates = [
                    self.createDate(day: 25), // Monday
                    self.createDate(day: 26), // Tuesday
                    self.createDate(day: 27), // Wednesday
                    self.createDate(day: 28), // Thursday
                    self.createDate(day: 29), // Friday
                    self.createDate(day: 30), // Saturday
                    self.createDate(day: 31)  // Sunday
                ]

                self.weeklyWorkouts = WeeklyWorkoutData(
                    currentWeekWorkouts: 0,
                    weeklyGoal: 5,
                    weekDates: weekDates
                )

                self.workoutHistory = [
                    WorkoutHistory(
                        id: "workout1",
                        location: "Helen Newman",
                        time: "6:30 PM",
                        date: "Fri Mar 29, 2024"
                    ),
                    WorkoutHistory(
                        id: "workout2",
                        location: "Teagle Up",
                        time: "7:15 PM",
                        date: "Thu Mar 28, 2024"
                    ),
                    WorkoutHistory(
                        id: "workout3",
                        location: "Helen Newman",
                        time: "6:32 PM",
                        date: "Tue Mar 26, 2024"
                    ),
                    WorkoutHistory(
                        id: "workout4",
                        location: "Toni Morrison",
                        time: "7:37 PM",
                        date: "Sun Mar 24, 2024"
                    ),
                    WorkoutHistory(
                        id: "workout5",
                        location: "Helen Newman",
                        time: "10:02 AM",
                        date: "Sat Mar 23, 2024"
                    )
                ]
            }
        }

        private func createDate(day: Int) -> Date {
            var components = DateComponents()
            components.year = 2024
            components.month = 3
            components.day = day
            return Calendar.current.date(from: components) ?? Date()
        }

        func toggleFavorite() {
            isFavorited.toggle()
        }

        func updateWorkoutProgress(newCount: Int) {
            // Animate workout progress update
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.weeklyWorkouts.currentWeekWorkouts = newCount
            }
        }
    }
}

struct UserProfile {
    let id: String
    let name: String
}

struct WeeklyWorkoutData {
    var currentWeekWorkouts: Int
    var weeklyGoal: Int
    var weekDates: [Date]

    var progressPercentage: Double {
        Double(currentWeekWorkouts) / Double(weeklyGoal)
    }
}

struct WorkoutHistory: Identifiable {
    let id: String
    let location: String
    let time: String
    let date: String
}

// do we have an extension of a date richie
extension Date {
    var dateStringLongMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}

#Preview{
    ProfileView()
}
