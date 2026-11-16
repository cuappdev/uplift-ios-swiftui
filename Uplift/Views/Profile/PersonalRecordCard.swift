//
//  PersonalRecordCard.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Charts
import SwiftUI

struct PersonalRecordCard: View {

    // MARK: - Properties

    let record: PersonalRecord
    let bestText: String
    let progressText: String
    var tilt: CGSize = .zero
    let onUpdate: () -> Void

    @State private var isFlipped = false

    private var isDark: Bool {
        record.tier == .starter
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)

            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .padding(Constants.PersonalRecords.cardPadding)
        .frame(width: Constants.PersonalRecords.cardSize.width, height: Constants.PersonalRecords.cardSize.height)
        .background(background)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .holographic(tilt: tilt, showsSheen: record.tier == .threePlates)
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }

    private var front: some View {
        VStack(spacing: Constants.PersonalRecords.cardSpacing) {
            seal

            Text(record.lift)
                .font(Constants.Fonts.h1)
                .foregroundStyle(isDark ? Constants.Colors.yellow : Constants.Colors.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)

            Text(bestText)
                .font(Constants.Fonts.f2)
                .foregroundStyle(isDark ? Constants.Colors.gray02 : Constants.Colors.black.opacity(0.75))

            updateButton
        }
    }

    private var back: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(record.lift)
                .font(Constants.Fonts.h2)
                .foregroundStyle(textColor)

            Chart(record.history, id: \.date) { entry in
                LineMark(x: .value("Date", entry.date), y: .value("Weight", entry.weight))
                    .interpolationMethod(.catmullRom)
                PointMark(x: .value("Date", entry.date), y: .value("Weight", entry.weight))
            }
            .foregroundStyle(textColor)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 3)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                        .foregroundStyle(textColor)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                        .foregroundStyle(textColor)
                }
            }

            Text(progressText)
                .font(Constants.Fonts.labelBold)
                .foregroundStyle(textColor)
        }
    }

    private var textColor: Color {
        isDark ? Constants.Colors.yellow : Constants.Colors.black
    }

    private var seal: some View {
        Constants.Images.prSeal
            .resizable()
            .scaledToFit()
            .frame(width: Constants.PersonalRecords.sealSize, height: Constants.PersonalRecords.sealSize)
            .overlay {
                Image(systemName: "dumbbell.fill")
                    .font(Constants.Fonts.h1)
                    .rotationEffect(.degrees(-45))
                    .foregroundStyle(Constants.Colors.yellow)
            }
    }

    private var updateButton: some View {
        Button(action: onUpdate) {
            Text("Update")
                .font(Constants.Fonts.labelBold)
                .foregroundStyle(Constants.Colors.white)
                .padding(.horizontal, Constants.PersonalRecords.updateHorizontalPadding)
                .padding(.vertical, Constants.PersonalRecords.updateVerticalPadding)
                .background(Constants.Colors.black)
                .overlay(Capsule().stroke(Constants.Colors.yellow, lineWidth: 1.5))
                .clipShape(Capsule())
        }
    }

    private var background: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.PersonalRecords.cardCornerRadius)
        return shape
            .fill(LinearGradient(colors: fillColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                shape
                    .inset(by: Constants.PersonalRecords.borderInset)
                    .stroke(
                        LinearGradient(colors: borderColors, startPoint: .top, endPoint: .bottom),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Constants.Colors.black.opacity(0.25), radius: 8, y: 4)
    }

    private var fillColors: [Color] {
        switch record.tier {
        case .starter:
            Constants.PersonalRecords.blackCard
        case .onePlate:
            Constants.PersonalRecords.orangeCard
        case .twoPlates, .threePlates:
            Constants.PersonalRecords.goldCard
        }
    }

    private var borderColors: [Color] {
        isDark
            ? [Constants.Colors.lightYellow, Constants.Colors.yellow]
            : [Constants.Colors.black, Constants.Colors.yellow]
    }

}
