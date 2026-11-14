//
//  BadgeView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BadgeView: View {

    // MARK: - Properties

    let badge: Badge
    let isEarned: Bool
    var progress: Double = 0
    var size: CGFloat = Constants.Badges.artSize
    var showsTitle = true

    private var isHidden: Bool {
        badge.isSecret && !isEarned
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: Constants.Badges.titleSpacing) {
            art
                .frame(width: size, height: size)
                .background(progressRing)

            if showsTitle {
                Text(isHidden ? "???" : badge.title)
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(isEarned ? Constants.Colors.black : Constants.Colors.gray03)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isHidden ? "Secret badge" : badge.title)
        .accessibilityValue(isEarned ? "Earned" : "Locked")
    }

    @ViewBuilder
    private var art: some View {
        if isHidden {
            symbol("questionmark")
        } else {
            Group {
                switch badge.art {
                case .flame(let level):
                    shape("badge_flame_\(level)", numberOffset: 0.18)
                case .gem(let level):
                    shape("badge_gem_\(level)", numberOffset: 0.06)
                case .wreath(let level):
                    shape("badge_wreath_\(level)", numberOffset: 0)
                case .symbol(let name):
                    symbol(name)
                }
            }
            .grayscale(isEarned ? 0 : 1)
            .opacity(isEarned ? 1 : Constants.Badges.lockedOpacity)
        }
    }

    private func shape(_ imageName: String, numberOffset: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .overlay {
                if let number = badge.number {
                    Text("\(number)")
                        .font(Constants.Badges.numberFont(for: size))
                        .foregroundStyle(Constants.Colors.black)
                        .offset(y: size * numberOffset)
                }
            }
    }

    private func symbol(_ name: String) -> some View {
        Circle()
            .fill(isHidden ? Constants.Colors.gray01 : Constants.Colors.yellow)
            .overlay {
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
                    .padding(size * (1 - Constants.Badges.symbolScale) / 2)
                    .foregroundStyle(isHidden ? Constants.Colors.gray03 : Constants.Colors.black)
            }
    }

    @ViewBuilder
    private var progressRing: some View {
        if !isEarned && progress > 0 {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Constants.Colors.yellow,
                    style: StrokeStyle(lineWidth: Constants.Badges.ringWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(-Constants.Badges.ringWidth * 2)
        }
    }

}
