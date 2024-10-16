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

    private var color: Color
    private var dismiss: DismissAction

    init(color: Color = Constants.Colors.white, dismiss: DismissAction) {
        self.color = color
        self.dismiss = dismiss
    }

    // MARK: - UI

    var body: some View {
        Button {
            dismiss()
        } label: {
            Constants.Images.arrowLeft
                .resizable()
                .scaledToFill()
                .foregroundStyle(color)
                .frame(width: 24, height: 24)
        }
    }

}
