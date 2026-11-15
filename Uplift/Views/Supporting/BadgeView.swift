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

            progressBar

            if showsTitle {
                Text(isHidden ? "???" : badge.title)
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(isEarned ? Constants.Colors.black : Constants.Colors.gray03)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
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
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .padding(size * (1 - Constants.Badges.symbolScale) / 2)
            .foregroundStyle(
                isHidden
                    ? AnyShapeStyle(Constants.Colors.gray02)
                    : AnyShapeStyle(LinearGradient(
                        colors: [Constants.Colors.yellow, Constants.Colors.orange],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            )
    }

    @ViewBuilder
    private var progressBar: some View {
        if !isEarned && progress > 0 {
            Capsule()
                .fill(Constants.Colors.gray01)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule()
                            .fill(Constants.Colors.yellow)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(width: size * Constants.Badges.progressBarScale, height: Constants.Badges.progressBarHeight)
        }
    }

}
