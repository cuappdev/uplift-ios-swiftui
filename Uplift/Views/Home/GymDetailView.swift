//
//  GymDetailView.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import NukeUI
import SwiftUI
import UpliftAPI
import WrappingHStack

/// Detailed view for a Gym.
struct GymDetailView: View {

    // MARK: - Properties

    let gym: Gym

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
        VStack(spacing: 0) {
            heroSection
            amenitiesSection

            Spacer()
        }
        .onAppear {
            viewModel.fetchDaysOfWeek(for: gym)
            viewModel.fetchBuildingHours(for: gym)
        }
    }

    // MARK: - Hero

    @MainActor
    private var heroSection: some View {
        ZStack(alignment: .center) {
            LazyImage(url: gym.imageUrl) { state in
                if let image = state.image {
                    image.centerCropped()
                }
            }

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
        .ignoresSafeArea(.all)
        .frame(height: 276)
    }

    private var viewHoursCircle: some View {
        ZStack {
            SemiCircleShape()
                .fill(Constants.Colors.white)
                .frame(width: 120, height: 120)

            VStack(spacing: 4) {
                Spacer()

                switch gym.status {
                case .closed:
                    Text("CLOSED")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.closed)
                case .open:
                    Text("OPEN")
                        .font(Constants.Fonts.h3)
                        .foregroundStyle(Constants.Colors.open)
                case .none:
                    EmptyView()
                }

                viewHoursButton
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

}

#Preview {
    GymDetailView(gym: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman))
}
