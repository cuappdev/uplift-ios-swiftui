//
//  Image+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
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
