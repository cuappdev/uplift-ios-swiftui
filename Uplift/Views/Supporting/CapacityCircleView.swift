//
//  CapacityCircleView.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing a capacity circle.
struct CapacityCircleView: View {

    // MARK: Properties

    let circleWidth: CGFloat
    let closeStatus: Status?
    var outlineColor: Color = Constants.Colors.gray02
    let status: CapacityStatus?
    let textFont: Font

    @State private var color: Color = Constants.Colors.open
    @State private var progress: Double = 0.0

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(outlineColor, lineWidth: circleWidth)

            switch closeStatus {
            case .closed:
                Text("CLOSED")
                    .font(textFont)
                    .foregroundStyle(outlineColor)
            case .open:
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: circleWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(color)
                    .rotationEffect(Angle(degrees: 270))

                Text(progress.percentString)
                    .font(textFont)
                    .foregroundStyle(Constants.Colors.black)
            case nil:
                EmptyView()
            }
        }
        .onAppear {
            switch status {
            case .notBusy(let double):
                color = Constants.Colors.open
                progress = double
            case .slightlyBusy(let double):
                color = Constants.Colors.orange
                progress = double
            case .veryBusy(let double):
                color = Constants.Colors.red
                progress = double
            case nil:
                break
            }
        }
    }

}

extension CapacityCircleView {

    /// Skeleton view for a capacity circle.
    struct Skeleton: View {
        var circleWidth: CGFloat = 4
        var progress: Double = 0.0

        @State private var color: Color = Constants.Colors.open

        var body: some View {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Constants.Colors.gray02, lineWidth: 4)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: circleWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(color)
                    .rotationEffect(Angle(degrees: 270))
            }
            .onChange(of: progress) { progress in
                if progress < 0.5 {
                    color = Constants.Colors.open
                } else if progress < 0.8 {
                    color = Constants.Colors.orange
                } else {
                    color = Constants.Colors.red
                }
            }
        }
    }

}

#Preview {
    CapacityCircleView(
        circleWidth: 9,
        closeStatus: .closed(openTime: Date()),
        status: .notBusy(0.2),
        textFont: Constants.Fonts.labelBold
    )
}
