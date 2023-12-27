//
//  Image+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Image {

    /// Center crop an image and scale to fill.
    func centerCropped() -> some View {
        GeometryReader { geometry in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }

}
