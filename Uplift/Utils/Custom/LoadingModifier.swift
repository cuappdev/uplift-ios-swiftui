//
//  LoadingModifier.swift
//  Uplift
//
//  Created by jiwon jeong on 9/24/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                CustomLoadingView()
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}
