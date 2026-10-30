//
//  HideOnRemovalModifier.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 10/30/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HideOnRemovalModifier: ViewModifier, Animatable {

    var visibility: Double

    var animatableData: Double {
        get { visibility }
        set { visibility = newValue }
    }

    func body(content: Content) -> some View {
        content
            .opacity(visibility < 1 ? 0 : 1)
    }

}

extension AnyTransition {

    static var hideOnRemoval: AnyTransition {
        .asymmetric(
            insertion: .identity,
            removal: .modifier(
                active: HideOnRemovalModifier(visibility: 0),
                identity: HideOnRemovalModifier(visibility: 1)
            )
        )
    }

}
