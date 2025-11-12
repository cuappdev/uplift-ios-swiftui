//
//  LoadingModifier.swift
//  Uplift
//
//  Created by jiwon jeong on 9/24/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct LoadingModifier<LoadingView: View>: ViewModifier {
    let isLoading: Bool
    let loadingView: LoadingView

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                loadingView
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
    // Duru edited
}

extension View {
    func loading<LoadingView: View>(
        _ isLoading: Bool,
        @ViewBuilder loadingView: () -> LoadingView
    ) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, loadingView: loadingView()))
    }
}
