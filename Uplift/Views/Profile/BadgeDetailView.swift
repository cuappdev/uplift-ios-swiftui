//
//  BadgeDetailView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BadgeDetailView: View {

    // MARK: - Properties

    let badge: Badge
    @ObservedObject var viewModel: AchievementsView.ViewModel
    let onClose: () -> Void

    @StateObject private var motion = MotionManager()
    @State private var dragTilt: CGSize = .zero
    @State private var isRevealed = false
    @State private var showsText = false

    private var tilt: CGSize {
        CGSize(
            width: max(-1, min(1, motion.tilt.width + dragTilt.width)),
            height: max(-1, min(1, motion.tilt.height + dragTilt.height))
        )
    }

    private var isEarned: Bool {
        viewModel.isEarned(badge)
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Constants.Colors.black.opacity(Constants.BadgeDetail.backdropOpacity))
                .ignoresSafeArea()

            VStack(spacing: Constants.BadgeDetail.spacing) {
                art
                    .gesture(tiltGesture)
                text
            }
            .padding(.horizontal, Constants.BadgeDetail.horizontalPadding)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onClose)
        .onAppear(perform: reveal)
        .onDisappear(perform: motion.stop)
    }

    private var art: some View {
        ZStack {
            if isEarned {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Constants.Colors.yellow.opacity(Constants.BadgeDetail.glowOpacity), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: Constants.BadgeDetail.glowSize / 2
                        )
                    )
                    .frame(width: Constants.BadgeDetail.glowSize, height: Constants.BadgeDetail.glowSize)
                    .scaleEffect(isRevealed ? 1 : 0.3)
                    .opacity(isRevealed ? 1 : 0)
            }

            BadgeView(
                badge: badge,
                isEarned: isEarned,
                size: Constants.BadgeDetail.artSize,
                showsTitle: false
            )
            .holographic(tilt: isEarned ? tilt : .zero, showsSheen: isEarned && badge.isLegendary)
            .rotation3DEffect(.degrees(isRevealed ? 0 : Constants.BadgeDetail.spinDegrees), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(isRevealed ? 1 : 0.2)
        }
    }

    private var tiltGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragTilt = CGSize(
                    width: value.translation.width / Constants.Holographic.dragDistance,
                    height: value.translation.height / Constants.Holographic.dragDistance
                )
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                    dragTilt = .zero
                }
            }
    }

    private var text: some View {
        VStack(spacing: 8) {
            Text(badge.isSecret && !isEarned ? "???" : badge.title)
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.white)

            Text(viewModel.summary(of: badge))
                .font(Constants.Fonts.h3)
                .foregroundStyle(isEarned ? Constants.Colors.yellow : Constants.Colors.gray02)

            Text(viewModel.detail(of: badge))
                .font(Constants.Fonts.bodyNormal)
                .foregroundStyle(Constants.Colors.gray02)
                .multilineTextAlignment(.center)
        }
        .opacity(showsText ? 1 : 0)
        .offset(y: showsText ? 0 : Constants.BadgeDetail.textOffset)
    }

    private func reveal() {
        if isEarned {
            motion.start()
        }
        Haptics.shared.play(isEarned ? .heavy : .light)
        withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
            isRevealed = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.35)) {
            showsText = true
        }
    }

}

extension View {

    func badgeDetail(_ badge: Binding<Badge?>, viewModel: AchievementsView.ViewModel) -> some View {
        overlay {
            if let selected = badge.wrappedValue {
                BadgeDetailView(badge: selected, viewModel: viewModel) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        badge.wrappedValue = nil
                    }
                }
                .transition(.opacity)
            }
        }
    }

}
