//
//  ShadowModifier.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view modifier that applies a shadow effect.
struct ShadowModifier: ViewModifier {

    var config: ShadowConfig

    func body(content: Content) -> some View {
        content
            .shadow(
                color: config.color,
                radius: config.radius,
                x: config.x,
                y: config.y
            )
    }

}

/// A configuration for a shadow effect.
struct ShadowConfig {

    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

}

extension View {

    @ViewBuilder
    func upliftShadow(_ config: ShadowConfig) -> some View {
        self
            .modifier(ShadowModifier(config: config))
    }

}
