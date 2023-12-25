//
//  HomeView.swift
//  Uplift
//
//  Created by Vin Bui on 11/25/23.
//

import SwiftUI

/// The main view for the Home page.
struct HomeView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        VStack {
            header
            scrollContent
        }
        .onAppear {
            viewModel.fetchAllGyms()
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
                leading: Constants.Padding.horizontal,
                bottom: 12,
                trailing: Constants.Padding.horizontal
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

            if let gyms = viewModel.gyms {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        capacityCircle(facility: gyms.facilityWithID(id: Constants.FacilityIDs.hnhFitness))

                        capacityCircle(facility: gyms.facilityWithID(id: Constants.FacilityIDs.teagleUp))
                    }

                    HStack(spacing: 12) {
                        capacityCircle(facility: gyms.facilityWithID(id: Constants.FacilityIDs.teagleDown))

                        capacityCircle(facility: gyms.facilityWithID(id: Constants.FacilityIDs.noyesFitness))
                    }

                    capacityCircle(facility: gyms.facilityWithID(id: Constants.FacilityIDs.morrFitness))
                }
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

                Text(facility.name)
                    .font(Constants.Fonts.bodyMedium)
                    .foregroundStyle(Constants.Colors.black)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                viewModel.showCapacities ? capacitiesView : nil

                Text("GYMS")
                    .foregroundStyle(Constants.Colors.gray03)
                    .font(Constants.Fonts.h3)

                switch viewModel.gyms {
                case .none:
                    // TODO: Shimmer Load
                    EmptyView()
                case .some(let gyms):
                    ForEach(gyms, id: \.self) { gym in
                        HomeGymCell(gym: gym)
                    }
                }
            }
            .padding(
                EdgeInsets(
                    top: 12,
                    leading: Constants.Padding.horizontal,
                    bottom: 32,
                    trailing: Constants.Padding.horizontal
                )
            )
        }
    }

    private var filterButton: some View {
        Button {
            // Only toggle if gyms are loaded
            guard viewModel.gyms != nil else { return }
            withAnimation(.easeOut) {
                viewModel.showCapacities.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                CapacityCircleView.Skeleton()
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

}

#Preview {
    HomeView()
}
