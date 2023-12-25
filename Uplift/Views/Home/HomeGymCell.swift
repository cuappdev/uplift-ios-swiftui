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
        }
    }

}

#Preview {
    HomeGymCell(
        gym: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman)
    )
}
