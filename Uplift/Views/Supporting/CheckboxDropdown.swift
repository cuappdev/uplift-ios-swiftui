//
//  CheckboxDropdown.swift
//  Uplift
//
//  Created by Sandy Yang on 10/14/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// An expandable section that lets the user select multiple options using checkboxes.
struct CheckboxDropdown: View {

   // MARK: - Properties

   let title: String
   let options: [String]

   @Binding var selection: Set<String>
   @State private var isExpanded = false

   // MARK: - UI

   var body: some View {
       VStack(alignment: .leading, spacing: 16) {
           header

           if isExpanded {
               ForEach(options, id: \.self) { option in
                   optionRow(for: option)
               }
           }
       }
       .padding(.horizontal, 16)
       .padding(.vertical, 24)
   }

   private var header: some View {
       Button {
           withAnimation {
               isExpanded.toggle()
           }
       } label: {
           HStack(spacing: 6) {
               Text(title)
                   .font(Constants.Fonts.h4)
                   .foregroundStyle(Constants.Colors.gray04)

               if !selection.isEmpty {
                   Circle()
                       .fill(Constants.Colors.yellow)
                       .frame(width: 6, height: 6)
               }

               Spacer(minLength: 8)

               Text(options.filter { selection.contains($0) }.joined(separator: " · "))
                   .font(Constants.Fonts.bodyLight)
                   .foregroundStyle(Constants.Colors.black)
                   .lineLimit(1)

               Constants.Images.chevronRight
                   .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
           }
       }
       .buttonStyle(.plain)
   }

    private func optionRow(for option: String) -> some View {
        Button {
            selection.toggle(option)
        } label: {
            HStack {
                Text(option)
                    .font(Constants.Fonts.bodyLight)
                    .foregroundStyle(Constants.Colors.black)

                Spacer()

                checkbox(isSelected: selection.contains(option))
            }
        }
        .buttonStyle(.plain)
    }

    private func checkbox(isSelected: Bool) -> some View {
        Rectangle()
            .fill(isSelected ? Constants.Colors.yellow : Constants.Colors.white)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Constants.Colors.gray04, lineWidth: 0.8)
                    .frame(width: 20, height: 20)
            )
            .frame(width: 14, height: 14)
    }

}

#Preview {
    CheckboxDropdownPreview()
}

private struct CheckboxDropdownPreview: View {

   @State private var selection: Set<String> = ["Barre"]

   var body: some View {
       CheckboxDropdown(
           title: "CLASS TYPE",
           options: ["Spinning", "Barre", "H.I.I.T."],
           selection: $selection
       )
   }

}
