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
                ForEach(Array(options.enumerated()), id: \.element) { _, option in
                    chip(for: option)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func chip(for option: String) -> some View {
        let isSelected = selection.contains(option)

        return Button {
            selection.toggle(option)
        } label: {
            Text(option)
                .font(Constants.Fonts.labelSemibold)
                .foregroundStyle(Constants.Colors.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Constants.Colors.yellow : Constants.Colors.white)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.clear : Constants.Colors.gray04, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 11.33/2)
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
