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
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .padding(20)
                .background(Color(.systemBackground).opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 10)
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
