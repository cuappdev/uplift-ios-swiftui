//
//  PersonalRecordStack.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PersonalRecordStack: View {

    // MARK: - Properties

    @ObservedObject var viewModel: PersonalRecordsView.ViewModel
    let onUpdate: (PersonalRecord) -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var topIndex = 0

    private var orderedRecords: [PersonalRecord] {
        let records = viewModel.records
        guard !records.isEmpty else { return [] }

        let start = topIndex % records.count
        return Array(records[start...] + records[..<start])
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            let visible = Array(orderedRecords.prefix(Constants.PersonalRecords.visibleCards).enumerated())
            ForEach(visible, id: \.element.id) { index, record in
                card(record, depth: index)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: Constants.PersonalRecords.cardSize.height)
    }

    private func card(_ record: PersonalRecord, depth: Int) -> some View {
        let isTop = depth == 0
        return PersonalRecordCard(
            record: record,
            bestText: viewModel.bestText(of: record),
            progressText: viewModel.progressText(of: record),
            tilt: isTop ? tilt : .zero
        ) {
            onUpdate(record)
        }
        .scaleEffect(1 - CGFloat(depth) * Constants.PersonalRecords.depthScale, anchor: .trailing)
        .offset(x: CGFloat(depth) * Constants.PersonalRecords.depthOffset)
        .offset(isTop ? dragOffset : .zero)
        .rotationEffect(.degrees(isTop ? dragOffset.width / Constants.PersonalRecords.dragRotationDivisor : 0))
        .zIndex(Double(-depth))
        .simultaneousGesture(isTop ? swipeGesture : nil)
    }

    private var tilt: CGSize {
        CGSize(
            width: dragOffset.width / Constants.Holographic.dragDistance,
            height: dragOffset.height / Constants.Holographic.dragDistance
        )
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: Constants.PersonalRecords.dragMinimumDistance)
            .onChanged { value in
                guard isHorizontal(value.translation) else { return }
                dragOffset = CGSize(width: value.translation.width, height: value.translation.height / 4)
            }
            .onEnded { value in
                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                    if isHorizontal(value.translation)
                        && abs(value.translation.width) > Constants.PersonalRecords.swipeThreshold
                        && viewModel.records.count > 1 {
                        topIndex += 1
                        Haptics.shared.play(.light)
                    }
                    dragOffset = .zero
                }
            }
    }

    private func isHorizontal(_ translation: CGSize) -> Bool {
        abs(translation.width) > abs(translation.height)
    }

}
