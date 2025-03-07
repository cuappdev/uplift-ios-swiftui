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

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                profileTopSection
                goalView
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.top, 24)
        }
        .refreshable {
            viewModel.fetchUserProfile()
        }
    }

    private var profileTopSection: some View {
        HStack(spacing: 24) {
            // Profile image with camera icon
            ZStack(alignment: .bottomTrailing) {
                Constants.Images.profileEmpty                         .resizable()
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
                                .foregroundStyle(Constants.Colors.yellow)

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

    private var goalView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("GOALS")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.gray04)

                Spacer()

                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 6)
                    .foregroundStyle(Constants.Colors.gray03)
                    .rotationEffect(.degrees(-90))

            }
        }
    }
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
