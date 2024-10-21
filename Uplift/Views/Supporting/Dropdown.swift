//
//  Dropdown.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/16/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct Dropdown: View {

    // MARK: - Properties

    @Binding var displayError: Bool
    @Binding var isExpanded: Bool
    @Binding var selectedOption: String
    let options: [String]

    var body: some View {
        VStack(spacing: 8) {
            dropdown

            displayError ? (
                HStack {
                    Text("This is a required field.")
                        .foregroundStyle(Constants.Colors.red)
                        .font(Constants.Fonts.error)
                        .padding(.leading, 4)

                    Spacer()
                }
            ) : nil
        }
    }

    private var dropdown: some View {
        VStack(spacing: 8) {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Text(selectedOption.isEmpty || isExpanded ? "Choose an option..." : selectedOption)
                        .foregroundStyle(selectedOption.isEmpty || isExpanded
                                         ? Constants.Colors.gray04
                                         : Constants.Colors.black)
                        .font(Constants.Fonts.f3)

                    Spacer()

                    Constants.Images.chevronDown
                }
                .padding(.horizontal, 8)
            }

            isExpanded ? (
                ForEach(options, id: \.self) { option in
                    Button {
                        selectedOption = option
                        displayError = false
                    } label: {
                        HStack {
                            Text(option)
                                .foregroundStyle(Constants.Colors.black)
                                .font(selectedOption == option ? Constants.Fonts.h3 : Constants.Fonts.f3)

                            Spacer()
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedOption == option ? Constants.Colors.dropdownSelectColor : .clear)
                        )
                    }
                }
            ) : nil
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Constants.Colors.gray01)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(displayError ? Constants.Colors.red : .clear, lineWidth: 1)
        )
    }
}
