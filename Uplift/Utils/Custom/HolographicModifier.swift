//
//  HolographicModifier.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HolographicModifier: ViewModifier {

    // MARK: - Properties

    let tilt: CGSize
    let showsSheen: Bool

    // MARK: - UI

    func body(content: Content) -> some View {
        content
            .overlay {
                if showsSheen {
                    LinearGradient(
                        colors: Constants.Holographic.sheenColors,
                        startPoint: UnitPoint(x: tilt.width - 0.5, y: tilt.height - 0.5),
                        endPoint: UnitPoint(x: tilt.width + 1.5, y: tilt.height + 1.5)
                    )
                    .mask(content)
                    .opacity(Constants.Holographic.sheenOpacity)
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
                }
            }
            .rotation3DEffect(
                .degrees(tilt.width * Constants.Holographic.maxRotation),
                axis: (x: 0, y: 1, z: 0)
            )
            .rotation3DEffect(
                .degrees(-tilt.height * Constants.Holographic.maxRotation),
                axis: (x: 1, y: 0, z: 0)
            )
    }

}

extension View {

    func holographic(tilt: CGSize, showsSheen: Bool) -> some View {
        modifier(HolographicModifier(tilt: tilt, showsSheen: showsSheen))
    }

}
