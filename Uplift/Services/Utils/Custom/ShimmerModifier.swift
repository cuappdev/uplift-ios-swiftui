//
//  ShimmerModifier.swift
//  Uplift
//
//  Created by Vin Bui on 1/6/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view modifier that applies a shimmer effect.
struct ShimmerEffect: ViewModifier {

    @State private var moveTo: CGFloat = -1.5
    var config: ShimmerConfig

    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(
                                                colors: [
                                                    .white.opacity(0),
                                                    config.highlight.opacity(config.highlightOpacity),
                                                    .white.opacity(0)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: 100)
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: config.degrees))
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 1.5
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }

}

/// A configuration for a shimmer effect.
struct ShimmerConfig {

    var tint: Color = Color.gray.opacity(0.3)
    var highlight: Color
    var blur: CGFloat
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 1
    var degrees: CGFloat = -70

}

extension ShimmerConfig {

    // MARK: - Shimmer Presets

    static var small: ShimmerConfig {
        ShimmerConfig(
            highlight: Color.white,
            blur: 10,
            speed: 1.5,
            degrees: 70
        )
    }

    static var medium: ShimmerConfig {
        ShimmerConfig(
            highlight: Color.white,
            blur: 20,
            speed: 1.5,
            degrees: 70
        )
    }

    static var large: ShimmerConfig {
        ShimmerConfig(
            highlight: Color.white.opacity(0.85),
            blur: 30,
            speed: 1.3,
            degrees: 70
        )
    }

}

extension View {

    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffect(config: config))
    }

}
