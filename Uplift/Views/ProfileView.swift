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
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @EnvironmentObject var tabBarProp: TabBarProperty

    private let radius = 125

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
        .padding(.bottom, 12)
        .padding(.horizontal, Constants.Padding.homeHorizontal)
        .background(
            Constants.Colors.white
                .upliftShadow(Constants.Shadows.smallLight)
        )
        .ignoresSafeArea(.all)
        .frame(height: 64)
    }

    private var settingsButton: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(Constants.Colors.yellow)

                Text("Favorites")
                    .font(Constants.Fonts.bodyLight)
                    .foregroundStyle(Constants.Colors.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Constants.Colors.white)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Constants.Colors.yellow, lineWidth: 1)
            }

            Button {
                viewModel.showSettingsSheet = true
            } label: {
                Constants.Images.settings
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Constants.Colors.black)
            }
            .sheet(isPresented: $viewModel.showSettingsSheet) {
                settingsView
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
                //TODO: Learn more about uplift
            } label: {
                HStack {
                    Text("About Uplift")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                }
            }

            DividerLine()

            Button {
                //TODO: Notifications about uplift
            } label: {
                HStack {
                    Text("Reminders")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                }
            }

            DividerLine()

            Button {
                //TODO: Reporting an Issue
            } label: {
                HStack {
                    Text("Report an Issue")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                }
            }

            DividerLine()

            Button {
                UserSessionManager.shared.logout()
                viewModel.showSettingsSheet = false
                mainViewModel.showMainView = false
                mainViewModel.showSignInView = true
            } label: {
                Text("Log Out")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.closed)
            }

            DividerLine()

            Button {
                viewModel.showDeleteAccountAlert = true
            } label: {
                Text("Delete Account")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.closed)
            }
            .alert("Delete Account", isPresented: $viewModel.showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteAccount()
                    mainViewModel.showMainView = false
                    mainViewModel.showSignInView = true
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Constants.Colors.white)
    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                profileTopSection
                goalView
                historyView
                    .padding(.bottom, CGFloat(radius))
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.top, 24)
        }
    }

    private var profileTopSection: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .fill(Constants.Colors.white)
                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
                        .frame(width: 98, height: 98)

                    Circle()
                        .fill(Constants.Colors.white)
                        .frame(width: 98, height: 98)

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 93)
                        .foregroundStyle(Constants.Colors.gray02)
                }

                Circle()
                    .fill(Constants.Colors.white)
                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Constants.Colors.gray03)
                    }
                    .offset(x: 2, y: 2)
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.user?.name ?? "Anonymous")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)

                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.totalGymDays)")
                            .font(Constants.Fonts.h2)
                            .foregroundStyle(Constants.Colors.black)

                        Text("Gym Days")
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.gray04)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(minWidth: 70, alignment: .leading)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.activeStreak)")
                            .font(Constants.Fonts.h2)
                            .foregroundStyle(Constants.Colors.black)

                        Text("Streaks")
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.gray04)
                    }
                    .frame(minWidth: 55, alignment: .leading)

                    // TODO: Replace with real badges count once available from API
                    VStack(alignment: .leading, spacing: 4) {
                        Text("0")
                            .font(Constants.Fonts.h2)
                            .foregroundStyle(Constants.Colors.black)

                        Text("Badges")
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.gray04)
                    }
                    .frame(minWidth: 55, alignment: .leading)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 2)
    }

    private var goalView: some View {
        NavigationLink {
            SetGoalsView(isOnboarding: false)
                .environmentObject(mainViewModel)
        } label: {
            VStack {
                HStack {
                    Text("My Goals")
                        .font(Constants.Fonts.h2)
                        .foregroundColor(Constants.Colors.gray04)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 12)
                        .foregroundColor(Constants.Colors.gray03)
                }

                VStack(spacing: CGFloat(-radius) + 16) {
                    WorkoutProgressArc(viewModel: viewModel)
                    WeeklyWorkoutTrackerView(viewModel: viewModel)
                }
            }
        }
    }

    private var historyView: some View {
        NavigationLink {
            WorkoutHistoryView()
        } label: {
            VStack(spacing: 20) {
                HStack {
                    Text("History")
                        .font(Constants.Fonts.h2)
                        .foregroundColor(Constants.Colors.gray04)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 12)
                        .foregroundColor(Constants.Colors.gray03)
                }

                ForEach(viewModel.workouts.indices, id: \.self) { index in
                    LazyVStack(spacing: 8) {
                        let workout = viewModel.workouts[index]

                        HStack {
                            Text(workout.gymName)
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.bodyMedium)

                            Spacer()

                            Text(formattedWorkoutTime(workout.workoutTime))
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.labelLight)
                        }

                        if index < viewModel.workouts.count - 1 {
                            Rectangle()
                                .fill(Constants.Colors.gray01)
                                .frame(height: 1)
                        }
                    }
                    // TODO: Temporary to allow view to take up whole screen
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Constants.Colors.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Constants.Colors.white)
            }
        }
    }

    // MARK: - Helpers

    private func formattedWorkoutTime(_ isoString: String) -> String {
        let parser = ISO8601DateFormatter()
        guard let date = parser.date(from: isoString) else { return isoString }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, yyyy"

        return "\(timeFormatter.string(from: date)) • \(dateFormatter.string(from: date))"
    }
}

#Preview {
    ProfileView(viewModel: ProfileView.ViewModel())
}
