//
//  MuscleGroupView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import UpliftAPI
import SwiftUI

/// A view representing a muscle group drop down view.
struct MuscleGroupView: View {

    // MARK: Properties

    var muscle: MuscleGroup
    let equipment: [Equipment]

    @State private var isExpanded: Bool = true

    // MARK: - UI

    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Text(muscle.description)
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.bodyNormal)

                    Spacer()

                    DropDownArrow(isExpanded: $isExpanded)
                }

                VStack(spacing: 12) {
                    if isExpanded {
                        ForEach(equipment.filter { $0.muscleGroup.contains(muscle) }, id: \.self) { equip in
                            if let quantity = equip.quantity, quantity != 0 {
                                HStack(spacing: 6) {
                                    Text("\(quantity)")

                                    Text(equip.name)

                                    Spacer()
                                }
                                .foregroundStyle(Constants.Colors.black)
                                .font(Constants.Fonts.bodyMedium)
                            }
                        }
                    }
                }
                .padding(.leading, 12)
            }
        }
    }

}
