//
//  StretchyModifier.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/11/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view modifier that applies a stretchy effect to the header image.
struct StretchyModifier: ViewModifier {

    var geometry: GeometryProxy

    func body(content: Content) -> some View {
        let minY = geometry.frame(in: .global).minY
        let originY = geometry.frame(in: .global).origin.y
        let height = geometry.size.height

        content
            .frame(height: minY > 0 ? height + originY : height)
            .clipped()
            .offset(y: minY > 0 ? -minY : 0)
    }

}

extension View {

    @ViewBuilder
    func stretchy(_ geometry: GeometryProxy) -> some View {
        self
            .modifier(StretchyModifier(geometry: geometry))
    }

}
