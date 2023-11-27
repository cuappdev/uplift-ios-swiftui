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
//        Text(viewModel.headingText)
//            .font(Constants.Fonts.h1)
        HomeGymCell(gym: DummyData.default.getGym(data: DummyData.DummyGym.helenNewman))
    }
}

#Preview {
    HomeView()
}
