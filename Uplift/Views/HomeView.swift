//
//  HomeView.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The main view for the Home page.
struct HomeView: View {

    // MARK: - Properties

    @State var popupIsPresented: Bool = false
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var viewModel = ViewModel()
    @State var popupSubmitted: Bool = false

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
            viewModel.setupEnvironment(with: locationManager)
            viewModel.fetchAllGyms()
        }
        .blur(radius: popupIsPresented ? 0.4 : 0)
        .disabled(popupIsPresented)
        if popupIsPresented {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Constants.Colors.gray04.opacity(0.5))
            if !popupSubmitted {
                GiveawayPopup(popupSubmitted: $popupSubmitted, popupIsPresented: $popupIsPresented)
                    .shadow(radius: 10)
            } else {
                GiveawayResponse(popupIsPresented: $popupIsPresented)
            }
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Text(viewModel.headingText)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h1)

                Spacer()

                filterButton
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

    private var capacitiesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GYM CAPACITIES")
                .foregroundStyle(Constants.Colors.gray03)
                .font(Constants.Fonts.h3)

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    capacityCircleNavLink(fitnessCenterName: Constants.FacilityNames.hnhFitness)

                    capacityCircleNavLink(fitnessCenterName: Constants.FacilityNames.teagleUp)
                }

                HStack(spacing: 12) {
                    capacityCircleNavLink(fitnessCenterName: Constants.FacilityNames.teagleDown)

                    capacityCircleNavLink(fitnessCenterName: Constants.FacilityNames.noyesFitness)
                }

                capacityCircleNavLink(fitnessCenterName: Constants.FacilityNames.morrFitness)
            }
        }
        .transition(.move(edge: .top))
    }

    private func capacityCircle(facility: Facility?) -> some View {
        VStack(spacing: 12) {
            if let facility {
                CapacityCircleView(
                    circleWidth: 9,
                    closeStatus: facility.status,
                    status: facility.capacity?.status,
                    textFont: Constants.Fonts.labelBold
                )
                .frame(width: 72, height: 72)

                VStack(spacing: 4) {
                    Text(facility.name.replacing(" Fitness Center", with: ""))
                        .font(Constants.Fonts.bodyMedium)
                        .foregroundStyle(Constants.Colors.black)

                    capacityDescription(facility: facility)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
    }

    private func capacityDescription(facility: Facility) -> some View {
        Group {
            switch facility.status {
            case .closed:
                Text("Closed")
            case .open:
                Text("Updated \(facility.capacity?.updated.timeStringTrailingZeros ?? "")")
            case .none:
                Text("No Data")
            }
        }
        .foregroundStyle(Constants.Colors.gray04)
        .font(Constants.Fonts.bodyLight)
    }

    private var giveawayButton: some View {
        VStack {
            Button {
                self.popupIsPresented = true
            } label: {
                Constants.Images.giveawayButton
                    .frame(width: 361, height: 102, alignment: .center)
            }
        }

    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                viewModel.showCapacities ? capacitiesView : nil

                giveawayButton
                HStack {
                    Text("GYMS")
                        .foregroundStyle(Constants.Colors.gray03)
                        .font(Constants.Fonts.h3)

                    Spacer()
                }

                switch viewModel.gyms {
                case .none:
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Constants.Colors.gray01)
                            .frame(height: 180)
                            .shimmer(.large)
                    }
                case .some(let gyms):
                    ForEach(gyms, id: \.self) { gym in
                        NavigationLink {
                            GymDetailView(gym: gym)
                        } label: {
                            HomeGymCell(gym: gym)
                        }
                        .contentShape(Rectangle()) // Fixes navigation link tap area
                        .buttonStyle(ScaleButtonStyle())
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                AnalyticsManager.shared.log(
                                    UpliftEvent.tapGymCell.toEvent(type: .gym, value: gym.name)
                                )
                            }
                        )
                    }
                }
            }
            .padding(
                EdgeInsets(
                    top: 12,
                    leading: Constants.Padding.homeHorizontal,
                    bottom: 32,
                    trailing: Constants.Padding.homeHorizontal
                )
            )
        }
        .refreshable {
            viewModel.refreshGyms()
        }
    }

    private var filterButton: some View {
        Button {
            // Only toggle if gyms are loaded
            guard viewModel.gyms != nil else { return }
            withAnimation(.easeOut) {
                viewModel.showCapacities.toggle()
            }
            AnalyticsManager.shared.log(
                UpliftEvent.tapCapacityToggle.toEvent()
            )
        } label: {
            HStack(spacing: 12) {
                CapacityCircleView.Skeleton(progress: viewModel.calculateAverageCapacity())
                    .frame(width: 24, height: 24)

                Triangle()
                    .fill(Constants.Colors.black)
                    .rotationEffect(Angle(degrees: viewModel.showCapacities ? 180 : 90))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
        )
    }

    // MARK: - Supporting

    private func capacityCircleNavLink(fitnessCenterName: String) -> some View {
        NavigationLink {
            if let gym = viewModel.gymWithFacility(
                viewModel.gyms?.facilityWithName(name: fitnessCenterName)
            ) {
                GymDetailView(gym: gym, isTeagleUpSelected: fitnessCenterName == Constants.FacilityNames.teagleUp)
            }
        } label: {
            capacityCircle(facility: viewModel.gyms?.facilityWithName(name: fitnessCenterName))
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                AnalyticsManager.shared.log(
                    UpliftEvent.tapCapacityCircle.toEvent(
                        type: .facility,
                        value: fitnessCenterName
                    )
                )
            }
        )
    }

}
//
//#Preview {
//    HomeView()
//}
