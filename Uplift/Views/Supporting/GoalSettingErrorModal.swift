//
//  GoalSettingErrorModal.swift
//  Uplift
//
//  Created by Caitlyn Jin on 4/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A modal for the goal setting warning popup.
struct GoalSettingErrorModal: View {

    // MARK: - Properties

    let onCancel: () -> Void
    let unlockDate: Date?

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Constants.Images.warning
                        .resizable()
                        .frame(width: 36, height: 36)

                    Text("Goals can only be changed after 1 month. The next time you can edit your goal is on \(nextEditDate).")
                        .font(Constants.Fonts.bodyNormal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Colors.black)
                }

                VStack(spacing: 8) {
                    Text("You can change your goal in:")
                        .font(Constants.Fonts.f4)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Colors.black)

                    Text("\(daysToNextEdit) DAYS")
                        .font(Constants.Fonts.s2)
                        .foregroundColor(Constants.Colors.black)
                }
            }
            .padding(.horizontal, 20)

            Button {
                onCancel()
            } label: {
                Constants.Images.crossThin
                    .foregroundColor(Constants.Colors.black)
                    .frame(width: 32, height: 32)
            }
            .offset(x: -10, y: -10)
        }
        .frame(width: 249, height: 235)
    }

    // MARK: - Helpers

    private var nextEditDate: String {
        guard let unlockDate else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy"
        return formatter.string(from: unlockDate)
    }

    private var daysToNextEdit: String {
        guard let unlockDate else { return "--" }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date.now)
        let target = calendar.startOfDay(for: unlockDate)
        let days = calendar.dateComponents([.day], from: start, to: target).day

        guard let days else { return "--" }
        return String(days)
    }

}
