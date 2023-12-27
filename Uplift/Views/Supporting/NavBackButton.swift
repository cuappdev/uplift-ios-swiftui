//
//  NavBackButton.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The view for the navigation bar back button.
struct NavBackButton: View {

    // MARK: - Properties

    let dismiss: DismissAction

    // MARK: - UI

    var body: some View {
        Button {
            dismiss()
        } label: {
            Constants.Images.arrowLeft
                .resizable()
                .scaledToFill()
                .foregroundStyle(Constants.Colors.white)
                .frame(width: 24, height: 24)
        }
    }

}
