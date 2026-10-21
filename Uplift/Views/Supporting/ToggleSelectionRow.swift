//
//  ToggleSelectionRow.swift
//  Uplift
//
//  Created by Sandy Yang on 10/14/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A horizontal row of options that can each be toggled on and off.
struct ToggleSelectionRow: View {

    // MARK: - Properties

    let options: [String]

    @Binding var selection: Set<String>

    // MARK: - UI

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(options.enumerated()), id: \.element) { index, option in
                    if index > 0 {
                        Rectangle()
                            .fill(Constants.Colors.gray01)
                            .frame(width: 1, height: 28)
                    }

                    chip(for: option)
                }
            }
        }
    }

    private func chip(for option: String) -> some View {
        let isSelected = selection.contains(option)

        return Button {
            selection.toggle(option)
        } label: {
            VStack(spacing: 6) {
                Text(option)
                    .font(isSelected ? Constants.Fonts.bodySemibold : Constants.Fonts.bodyLight)
                    .foregroundStyle(Constants.Colors.black)

                Circle()
                    .fill(Constants.Colors.yellow)
                    .frame(width: 6, height: 6)
                    .opacity(isSelected ? 1 : 0)
            }
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
    }

}

#Preview {
    ToggleSelectionRowPreview()
}

private struct ToggleSelectionRowPreview: View {

    @State private var selection: Set<String> = ["Noyes"]

    var body: some View {
        ToggleSelectionRow(
            options: ["Noyes", "Helen Newman", "Teagle", "Appel"],
            selection: $selection
        )
        .padding(16)
    }

}
