//
//  WorkoutCheckInView.swift
//  Uplift
//
//  Created by Duru Alayli on 11/15/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI
import ConfettiSwiftUI

/// View representing the workout check in pop-up
struct WorkoutCheckInView: View {

    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @ObservedObject var profileViewModel: ProfileView.ViewModel
    @ObservedObject var homeViewModel: HomeView.ViewModel
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        Group {
            if !viewModel.isCheckedIn {
                promptBody
            } else {
                successBody
            }
        }
        .onAppear {
            viewModel.gyms = homeViewModel.gyms ?? []
            viewModel.visibility = { _ in
                mainViewModel.showWorkoutCheckIn = true
            }

            if let gym = viewModel.currentNearestGym {
                viewModel.checkDailyCooldown()
                viewModel.checkCooldown(gym: gym)
            }

            LocationManager.shared.requestLocation()
            viewModel.findNearestGym()
        }
        .onChange(of: homeViewModel.gyms) { gyms in
            guard let gyms else { return }
            viewModel.updateGyms(gyms)
        }
    }

    private var promptBody: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading) {
                Text("We see you're near a gym...")
                    .font(Constants.Fonts.bodySemibold)
                    .foregroundStyle(Constants.Colors.black)

                Text(viewModel.nearestGymText)
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(Constants.Colors.gray04)
            }

            Spacer()

            HStack(spacing: 16) {
                checkInButton
                closeButton
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.Colors.white)
                .shadow(
                    color: Constants.Colors.gray01,
                    radius: 20,
                    x: 0,
                    y: 4
                )
        )
        .padding(.horizontal, 10)
    }

    private var successBody: some View {
        ZStack {
            HStack(spacing: 84) {
                Text("You're all set. Enjoy your workout!")
                    .font(Constants.Fonts.bodySemibold)
                    .foregroundStyle(Constants.Colors.black)

                closeButton
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Constants.Colors.white)
                    .shadow(
                        color: Constants.Colors.gray01,
                        radius: 20,
                        x: 0,
                        y: 4
                    )
            )
            .transition(.move(edge: .top).combined(with: .opacity))
        }
        .onAppear {
            if let gym = viewModel.currentNearestGym {
                viewModel.checkCooldown(gym: gym)
            }

            viewModel.trigger += 1

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(10))
                withAnimation(.easeInOut(duration: 0.3)) {
                    mainViewModel.showWorkoutCheckIn = false
                }
                viewModel.startDailyCooldown()
            }
        }
        .confettiCannon(
            trigger: $viewModel.trigger,
            num: 70,
            confettis: [.shape(.circle), .shape(.slimRectangle)],
            colors: [Constants.Colors.yellow, Constants.Colors.lightYellow],
            confettiSize: 12,
            rainHeight: 150,
            openingAngle: Angle.degrees(0),
            closingAngle: Angle.degrees(180),
            radius: 175
        )
        .padding(.horizontal, 10)
    }

    private var checkInButton: some View {
        Button {
            Task {
                await viewModel.handleCheckIn(user: profileViewModel.user)
                await profileViewModel.fetchUserProfile()
            }
        } label: {
            Text("Check In?")
                .font(Constants.Fonts.bodyMedium)
                .foregroundStyle(Constants.Colors.black)
                .padding(11)
                .background(Constants.Colors.lightYellow)
                .cornerRadius(11.1)
        }
    }

    private var closeButton: some View {
        Button(action: handleClose) {
            Constants.Images.close
                .resizable()
                .frame(width: 19, height: 19)
        }
    }

    private func handleClose() {
        withAnimation(.easeInOut(duration: 0.3)) {
            mainViewModel.showWorkoutCheckIn = false

            if let gym = viewModel.currentNearestGym {
                viewModel.startCooldown(gym: gym)
            }
        }
    }
}

#Preview {
    WorkoutCheckInView(
        profileViewModel: ProfileView.ViewModel(),
        homeViewModel: HomeView.ViewModel()
    )
}
