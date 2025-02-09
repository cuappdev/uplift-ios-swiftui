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
                    isExpanded ? (
                        ForEach(equipment.filter { $0.muscleGroup.contains(muscle) }, id: \.self) { equip in
                            HStack(spacing: 6) {
                                Text("\(equip.quantity ?? 0)")

                                Text(equip.name)

                                Spacer()
                            }
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.bodyMedium)
                        }
                    ) : nil
                }
                .padding(.leading, 12)
            }
        }
    }

}
