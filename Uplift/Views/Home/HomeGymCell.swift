//
//  HomeGymCell.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import Kingfisher
import SwiftUI

/// The cell representing a Gym used in the home page.
struct HomeGymCell: View {

    // MARK: - Properties

    let gym: Gym

    @State private var distance: String = "0.0"
    @EnvironmentObject var locationManager: LocationManager

    // MARK: - UI

    var body: some View {
        ZStack {
            KFImage(gym.imageUrl)
                .placeholder {
                    Constants.Colors.gray01
                }
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack {
                Spacer()

                gymInfoView
            }
        }
        .frame(height: 180)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
        .onChange(of: locationManager.userLocation) { _ in
            distance = locationManager.distanceToCoordinates(
                latitude: gym.latitude, longitude: gym.longitude
            )
        }
    }

    private var gymInfoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                gymNameText
                statusText
                capacityText
            }

            Spacer()

            VStack(alignment: .trailing) {
                facilityIcons

                Spacer()

                distanceText
            }
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 12, trailing: 12))
        .frame(height: 76)
        .background(Constants.Colors.white)
    }

    private var gymNameText: some View {
        Text(gym.name)
            .font(Constants.Fonts.f2)
            .foregroundStyle(Constants.Colors.black)
            .padding(.bottom, 2)
    }

    private var statusText: some View {
        HStack(spacing: 8) {
            switch gym.status {
            case .closed(let openTime):
                Text("Closed")
                    .foregroundStyle(Constants.Colors.closed)

                Text("Opens at \(openTime.timeStringNoTrailingZeros)")
                    .foregroundStyle(Constants.Colors.gray03)
            case .open(let closeTime):
                Text("Open")
                    .foregroundStyle(Constants.Colors.open)

                Text("Closes at \(closeTime.timeStringNoTrailingZeros)")
                    .foregroundStyle(Constants.Colors.gray03)
            case .none:
                EmptyView()
            }
        }
        .font(Constants.Fonts.labelMedium)
    }

    private var capacityText: some View {
        HStack(spacing: 8) {
            if gym.fitnessCenters.count == 2 {
                teagleCapacityView
            } else {
                switch gym.fitnessCenters.first?.capacity?.status {
                case .light(let double):
                    Text("Light")
                        .foregroundStyle(Constants.Colors.open)

                    percentFullText(double)
                case .cramped(let double):
                    Text("Cramped")
                        .foregroundStyle(Constants.Colors.orange)

                    percentFullText(double)
                case .full(let double):
                    Text("Full")
                        .foregroundStyle(Constants.Colors.closed)

                    percentFullText(double)
                case nil:
                    EmptyView()
                }
            }
        }
        .font(Constants.Fonts.labelMedium)
    }

    private func percentFullText(_ double: Double) -> some View {
        Text("\(double.percentString) full")
            .foregroundStyle(Constants.Colors.gray03)
    }

    @ViewBuilder
    private var teagleCapacityView: some View {
        switch gym.highestCapacityFC()?.capacity?.status {
        case .light:
            Text("Light")
                .foregroundStyle(Constants.Colors.open)
        case .cramped:
            Text("Cramped")
                .foregroundStyle(Constants.Colors.orange)
        case .full:
            Text("Full")
                .foregroundStyle(Constants.Colors.closed)
        case nil:
            EmptyView()
        }

        Text(
            // swiftlint:disable:next line_length
            "Up \(gym.facilityWithID(id: Constants.FacilityIDs.teagleUp)?.capacity?.percent.percentString ?? "0%") • Down \(gym.facilityWithID(id: Constants.FacilityIDs.teagleDown)?.capacity?.percent.percentString ?? "0%")"
        )
        .foregroundStyle(Constants.Colors.gray03)
    }

    private var facilityIcons: some View {
        HStack(spacing: 4) {
            ForEach(gym.facilities.duplicatesRemoved(), id: \.self) { facility in
                facility.facilityType?.iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Constants.Colors.gray04)
            }
        }
    }

    private var distanceText: some View {
        Text("\(distance)mi")
            .font(Constants.Fonts.labelMedium)
            .foregroundStyle(Constants.Colors.gray03)
    }

}

#Preview {
    HomeGymCell(
        gym: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman)
    )
}
