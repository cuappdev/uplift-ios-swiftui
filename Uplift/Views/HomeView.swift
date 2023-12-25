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
            capacitiesView
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
        VStack(alignment: .leading) {
            Text("GYM CAPACITIES")
                .foregroundStyle(Constants.Colors.gray03)
                .font(Constants.Fonts.h3)

            HStack {
                capacityCircle(facility: gym.facilityWithName(name: "Teagle "))
            }

            HStack {

            }


        }
    }

    @ViewBuilder
    private func capacityCircle(facility: Facility?) -> some View {
        if let facility {
            CapacityCircleView(
                circleWidth: 9,
                closeStatus: facility.status,
                status: facility.capacity?.status,
                textFont: Constants.Fonts.labelBold
            )
            .frame(width: 72, height: 72)
        }
    }

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
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

        } label: {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
        }
        .frame(width: 68, height: 40)
    }

}

#Preview {
    HomeView()
}
