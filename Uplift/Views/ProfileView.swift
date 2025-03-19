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
                //TODO: Logging Out functionality
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

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                profileTopSection
                goalView
                historyView
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.top, 24)
        }
    }

    private var profileTopSection: some View {
        HStack(spacing: 20) {
            // Profile image with camera icon
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    // Outer shadow circle
                    Circle()
                        .fill(Constants.Colors.white)
                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
                        .frame(width: 98, height: 98)

                    // White border circle
                    Circle()
                        .fill(Constants.Colors.white)
                        .frame(width: 98, height: 98)

                    // Profile image
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 93)
                        .foregroundStyle(Constants.Colors.gray02)
                }

                // Camera button overlay
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

            // Name and workouts count
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.profile?.name ?? "Anonymous")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)

                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.totalWorkouts)")
                            .font(Constants.Fonts.h2)
                            .foregroundStyle(Constants.Colors.black)

                        Text("Gym Days")
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.gray04)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(minWidth: 70, alignment: .leading)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.streaks)")
                            .font(Constants.Fonts.h2)
                            .foregroundStyle(Constants.Colors.black)

                        Text("Streaks")
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.gray04)
                    }
                    .frame(minWidth: 55, alignment: .leading)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.badges)")
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

    private var historyView: some View {
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

            ForEach(viewModel.workoutHistory.indices, id: \.self) { index in
                LazyVStack(spacing: 8) {
                    HStack {
                        let workout = viewModel.workoutHistory[index]
                        Text(workout.location)
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.bodyMedium)

                        Spacer()

                        Text("\(workout.time) • \(workout.date.description)")
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.labelLight)
                    }

                    if index < viewModel.workoutHistory.count - 1 {
                        Rectangle()
                            .fill(Constants.Colors.gray01)
                            .frame(height: 1)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
