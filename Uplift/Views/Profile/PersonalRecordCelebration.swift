//
//  PersonalRecordCelebration.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PersonalRecordCelebration: View {

    // MARK: - Properties

    let record: PersonalRecord
    @ObservedObject var viewModel: PersonalRecordsView.ViewModel
    let onClose: () -> Void

    @State private var isRevealed = false
    @State private var shareImage: Image?

    // MARK: - UI

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Constants.Colors.black.opacity(Constants.BadgeDetail.backdropOpacity))
                .ignoresSafeArea()

            if isRevealed {
                ConfettiView()
                    .ignoresSafeArea()
            }

            VStack(spacing: Constants.BadgeDetail.spacing) {
                Text("NEW PR!")
                    .font(Constants.Fonts.h1)
                    .tracking(Constants.BadgeDetail.bannerTracking)
                    .foregroundStyle(Constants.Colors.yellow)

                card
                    .rotation3DEffect(
                        .degrees(isRevealed ? 0 : Constants.BadgeDetail.spinDegrees),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .scaleEffect(isRevealed ? 1 : 0.2)

                if let shareImage {
                    ShareLink(item: shareImage, preview: SharePreview(record.lift, image: shareImage)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(Constants.Fonts.h3)
                            .foregroundStyle(Constants.Colors.black)
                            .padding(.horizontal, Constants.BadgeDetail.shareHorizontalPadding)
                            .padding(.vertical, Constants.BadgeDetail.shareVerticalPadding)
                            .background(Constants.Colors.yellow)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onClose)
        .onAppear(perform: reveal)
    }

    private var card: some View {
        PersonalRecordCard(
            record: record,
            bestText: viewModel.bestText(of: record),
            progressText: viewModel.progressText(of: record),
            showsUpdate: false,
            onUpdate: onClose
        )
        .allowsHitTesting(false)
    }

    private func reveal() {
        Haptics.shared.play(.heavy)
        withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
            isRevealed = true
        }

        let shareCard = card
            .padding(Constants.ShareCard.padding)
            .background(Constants.Colors.white)
        let renderer = ImageRenderer(content: shareCard)
        renderer.scale = Constants.ShareCard.renderScale
        shareImage = renderer.uiImage.map(Image.init(uiImage:))
    }

}
