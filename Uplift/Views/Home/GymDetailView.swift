//
//  GymDetailView.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import Kingfisher
import SwiftUI
import UpliftAPI
import WrappingHStack

/// Detailed view for a Gym.
struct GymDetailView: View {

    // MARK: - Properties

    let gym: Gym
    var isTeagleUpSelected: Bool = false

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ViewModel()

    // MARK: - Constants

    let padding = EdgeInsets(
        top: Constants.Padding.gymDetailSpacing,
        leading: Constants.Padding.gymDetailHorizontal,
        bottom: Constants.Padding.gymDetailSpacing,
        trailing: Constants.Padding.gymDetailHorizontal
    )

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            scrollContent
        }
        .ignoresSafeArea(.all)
        // TODO: Uncomment to add tab bar
//        .padding(.bottom)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavBackButton(dismiss: dismiss)
            }
        }
        .onAppear {
            viewModel.fetchDaysOfWeek()
            viewModel.fetchBuildingHours(for: gym)
            viewModel.determineSelectedTab(gym: gym, isTeagleUpSelected: isTeagleUpSelected)
        }
        .background(Constants.Colors.white)
    }

    private var scrollContent: some View {
        VStack(spacing: 0) {
            heroSection
            !gym.amenities.isEmpty ? amenitiesSection : nil
            slidingTabBar(gymName: viewModel.determineGymNameEnum(gym: gym))
            DividerLine()

            Group {
                if viewModel.selectedTab == .fitnessCenter {
                    FitnessCenterView(fc: gym.fitnessCenters.first)
                } else if viewModel.selectedTab == .teagleDown {
                    FitnessCenterView(fc: gym.facilityWithName(name: Constants.FacilityNames.teagleDown))
                } else if viewModel.selectedTab == .teagleUp {
                    FitnessCenterView(fc: gym.facilityWithName(name: Constants.FacilityNames.teagleUp))
                } else {
                    facilitiesView
                }
            }
            .padding(.horizontal, Constants.Padding.gymDetailHorizontal)
        }
        .padding(.bottom)
    }

    // MARK: - Hero

    @MainActor
    private var heroSection: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                KFImage(gym.imageUrl)
                    .placeholder {
                        Constants.Colors.gray01
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .stretchy(geometry)
            }
            .frame(height: 330)

            if viewModel.showHours {
                hoursView
            } else {
                Text(gym.name.uppercased())
                    .font(Constants.Fonts.h0)
                    .foregroundStyle(Constants.Colors.white)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
            }

            VStack {
                Spacer()

                viewHoursCircle
            }
        }
        .frame(height: 330)
    }

    private var viewHoursCircle: some View {
        ZStack {
            SemiCircleShape()
                .fill(Constants.Colors.white)
                .frame(width: 120, height: 120)

            VStack(spacing: 4) {
                Spacer()

                if gym.fitnessCenterIsOpen() {
                    Text("OPEN")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.open)
                        // Temporary padding to center status text while `viewHoursButton` is removed
                        .padding(12)
                } else {
                    Text("CLOSED")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.closed)
                        // Temporary padding to center status text while `viewHoursButton` is removed
                        .padding(12)
                }

                // TODO: Removed building hours. Determine what should be displayed here.
//                switch gym.status {
//                case .closed:
//                    Text("CLOSED")
//                        .font(Constants.Fonts.h3)
//                        .foregroundStyle(Constants.Colors.closed)
//                case .open:
//                    Text("OPEN")
//                        .font(Constants.Fonts.h3)
//                        .foregroundStyle(Constants.Colors.open)
//                case .none:
//                    EmptyView()
//                }
//
//                viewHoursButton
            }
            .frame(height: 120)
        }
    }

    private var viewHoursButton: some View {
        Button {
            Haptics.shared.play(.light)
            withAnimation {
                viewModel.showHours.toggle()
            }
            AnalyticsManager.shared.log(
                UpliftEvent.tapViewHoursGym.toEvent(type: .gym, value: gym.name)
            )
        } label: {
            Text(viewModel.showHours ? "Close Hours" : "View Hours")
                .font(Constants.Fonts.labelSemibold)
                .foregroundStyle(Constants.Colors.gray04)
                .underline()
        }
        .padding(.bottom, 4)
    }

    private var hoursView: some View {
        HStack(spacing: 8) {
            VStack(alignment: .trailing, spacing: 8) {
                ForEach(viewModel.daysOfWeek.indices, id: \.self) { index in
                    Text(viewModel.daysOfWeek[index])
                        .font(viewModel.daysOfWeek[index] == "Today" ? Constants.Fonts.h2 : Constants.Fonts.f2)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.buildingHours.first ?? "")
                    .font(Constants.Fonts.f2)

                ForEach(viewModel.buildingHours.dropFirst().indices, id: \.self) { index in
                    Text(viewModel.buildingHours[index])
                        .font(Constants.Fonts.f2Regular)
                }
            }
        }
        .foregroundStyle(Constants.Colors.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Constants.Colors.black.opacity(0.5)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }

    // MARK: - Amenities

    private var amenitiesSection: some View {
        WrappingHStack(
            gym.amenities,
            id: \.self,
            alignment: .center,
            spacing: .constant(0)
        ) { amenity in
            amenitiesCell(for: amenity)
        }
        .padding(padding)
    }

    private func amenitiesCell(for amenity: AmenityType) -> some View {
        HStack(spacing: 8) {
            switch amenity {
            case .showers:
                Constants.Images.shower
                    .frame(width: 18, height: 18)

                Text("Showers")
            case .lockers:
                Constants.Images.lock
                    .frame(width: 18, height: 18)

                Text("Lockers")
            case .parking:
                Constants.Images.parking
                    .frame(width: 18, height: 18)

                Text("Parking")
            case .elevators:
                Constants.Images.elevator
                    .frame(width: 18, height: 18)

                Text("Elevators/Lifts")
            }
        }
        .font(Constants.Fonts.f4)
        .foregroundStyle(Constants.Colors.black)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(Constants.Colors.gray01)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(4)
    }

    // MARK: - Facilities

    private func slidingTabBar(gymName: ViewModel.GymName) -> some View {
        switch gymName {
        case .teagle:
            SlidingTabBarView(
                config: SlidingTabBarView.TabBarConfig(),
                items: [
                    SlidingTabBarView.Item(
                        tab: GymTabType.teagleDown,
                        title: "TEAGLE DOWN"
                    ),
                    SlidingTabBarView.Item(
                        tab: GymTabType.teagleUp,
                        title: "TEAGLE UP"
                    ),
                    SlidingTabBarView.Item(
                        tab: GymTabType.facilities,
                        title: "FACILITIES"
                    )
                ],
                selectedTab: $viewModel.selectedTab
            )
        case .morrison:
            // TODO: Remove this logic once we figure out what 'Miscellaneous' means
            SlidingTabBarView(
                config: SlidingTabBarView.TabBarConfig(),
                items: [
                    SlidingTabBarView.Item(
                        tab: GymTabType.fitnessCenter,
                        title: "FITNESS CENTER"
                    )
                ],
                selectedTab: $viewModel.selectedTab
            )
        case .other:
            SlidingTabBarView(
                config: SlidingTabBarView.TabBarConfig(),
                items: [
                    SlidingTabBarView.Item(
                        tab: GymTabType.fitnessCenter,
                        title: "FITNESS CENTER"
                    ),
                    SlidingTabBarView.Item(
                        tab: GymTabType.facilities,
                        title: "FACILITIES"
                    )
                ],
                selectedTab: $viewModel.selectedTab
            )
        }
    }

    private var facilitiesView: some View {
        VStack(spacing: 0) {
            ForEach(gym.nonFCFacilities().indices, id: \.self) { index in
                FacilityExpandedView(facility: gym.nonFCFacilities()[index])
                    .padding(.vertical, 14)

                // Add a divider line if not the last one
                index != gym.nonFCFacilities().count - 1 ? DividerLine() : nil
            }
        }
    }

}

#Preview {
    GymDetailView(gym: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman))
}
