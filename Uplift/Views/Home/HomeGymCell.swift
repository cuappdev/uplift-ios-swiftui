//
//  HomeGymCell.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import NukeUI
import SwiftUI

/// The cell representing a Gym used in the home page.
struct HomeGymCell: View {

    // MARK: - Properties

    let gym: Gym

    // MARK: - UI

    var body: some View {
//        LazyImage(url: gym.imageUrl)
        VStack(alignment: .leading) {
            Text(gym.name)
                .font(Constants.Fonts.f2)
                .padding(.bottom, 4)

            statusText
                .padding(.bottom, 2)
        }
    }

    // MARK: - Supporting

    /// The view containing the status of the Gym as well as its closing time.
    private var statusText: some View {
        HStack(spacing: 8) {
            switch gym.status {
            case .closed(let closeTime):
                Text("Closed")
                    .foregroundStyle(Constants.Colors.closed)

                Text("Closes at \(closeTime.timeString)")
                    .foregroundStyle(Constants.Colors.gray03)
            case .open(let closeTime):
                Text("Open")
                    .foregroundStyle(Constants.Colors.open)

                Text("Closes at \(closeTime.timeString)")
                    .foregroundStyle(Constants.Colors.gray03)
            }
        }
        .font(Constants.Fonts.labelMedium)
    }

}

#Preview {
    HomeGymCell(
        gym: DummyData.default.getGym(data: DummyData.DummyGym.helenNewman)
    )
}
