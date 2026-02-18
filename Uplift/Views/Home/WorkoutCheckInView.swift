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

    @ObservedObject var homeViewModel: HomeView.ViewModel
    @ObservedObject var profileViewModel: ProfileView.ViewModel
    @ObservedObject var mainViewModel: MainView.ViewModel
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
            if let gym = viewModel.currentNearestGym {
                viewModel.checkDailyCooldown()
                viewModel.checkCooldown(gym: gym)
            }

            LocationManager.shared.requestLocation()

            viewModel.setupEnvironment(
                gyms: homeViewModel.gyms ?? []
            ) { show in
                mainViewModel.showWorkoutCheckIn = show
            }
        }
        .onChange(of: homeViewModel.gyms) { gyms in
            guard let gyms else { return }
            viewModel.updateGyms(gyms)
        }
    }

    private var promptBody: some View {
        HStack(spacing: 20) {
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
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
    }

    private var checkInButton: some View {
        Button(action: handleCheckIn) {
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

    private func handleCheckIn() {
        viewModel.isCheckedIn = true

        viewModel.performCheckIn(
            gymName: viewModel.currentNearestGym,
            profileViewModel: profileViewModel
        )
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
        homeViewModel: HomeView.ViewModel(),
        profileViewModel: ProfileView.ViewModel(),
        mainViewModel: MainView.ViewModel()
    )
}
