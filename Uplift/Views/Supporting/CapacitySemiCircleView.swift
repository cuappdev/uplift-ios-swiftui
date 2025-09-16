//
//  CapacitySemiCircleView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 11/21/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing a capacity semicircle.
struct CapacitySemiCircleView: View {

    // MARK: Properties

    let circleSize: CGFloat
    let closeStatus: Status?
    let lineWidth: CGFloat
    let status: CapacityStatus?
    let timeUpdated: Date?

    private var color: Color {
        switch status {
        case .notBusy:
            return Constants.Colors.open
        case .slightlyBusy:
            return Constants.Colors.orange
        case .veryBusy:
            return Constants.Colors.red
        default:
            return Constants.Colors.open
        }
    }
    private var progress: Double {
        switch status {
        case .notBusy(let double), .slightlyBusy(let double), .veryBusy(let double):
            return double
        default:
            return 0
        }
    }

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Constants.Colors.white)

            switch closeStatus {
            case .closed:
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(Constants.Colors.closed)
                    .rotationEffect(Angle(degrees: 180))

                VStack(spacing: 4) {
                    Text("CLOSED")
                        .font(Constants.Fonts.h2)
                        .foregroundStyle(Constants.Colors.closed)

                    HStack {
                        Text(timeUpdated?.timeStringTrailingZeros ?? "")
                            .font(Constants.Fonts.bodyNormal)
                            .foregroundStyle(Constants.Colors.gray04)

                        Constants.Images.replay
                    }

                    Spacer()
                }
                .padding(.top, circleSize / 6)  // Align text inside circle
            case .open:
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress / 2, 0.5)))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(color)
                    .rotationEffect(Angle(degrees: 180))

                VStack(spacing: 4) {
                    Text("\(progress.percentString) Full")
                        .font(Constants.Fonts.h2)
                        .foregroundStyle(color)

                    HStack {
                        Text(timeUpdated?.timeStringTrailingZeros ?? "")
                            .font(Constants.Fonts.bodyNormal)
                            .foregroundStyle(Constants.Colors.gray04)

                        Constants.Images.replay
                    }

                    Spacer()
                }
                .padding(.top, circleSize / 6)  // Align text inside circle
            case nil:
                EmptyView()
            }
        }
        .padding(lineWidth / 2)
    }

}

#Preview {
    CapacitySemiCircleView(
        circleSize: 160,
        closeStatus: .open(closeTime: Date()),
        lineWidth: 9,
        status: .slightlyBusy(0.9),
        timeUpdated: Date()
    )
}
