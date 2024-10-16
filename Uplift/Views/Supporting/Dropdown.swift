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

    @Binding var isExpanded: Bool
    let options: [String]
    @Binding var selectedOption: String

    var body: some View {
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
                                .foregroundStyle(selectedOption == option ? Constants.Colors.gray02 : .clear)
                        )
                    }
                }
            ) : nil
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Constants.Colors.gray01)
        )
    }
}
