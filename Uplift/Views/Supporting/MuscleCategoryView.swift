//
//  MuscleCategoryView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI

/// A view representing a muscle category drop down view.
struct MuscleCategoryView: View {

    // MARK: Properties

    var category: MuscleCategory
    let equipment: [Equipment]

    @State private var isExpanded: Bool = false

    // MARK: - UI

    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    category.image
                        .frame(width: 24, height: 24)

                    Text(category.description)
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f2)

                    Spacer()

                    DropDownArrow(isExpanded: $isExpanded)
                }

                if isExpanded {
                    ForEach(category.muscles, id: \.self) { muscleGroup in
                        MuscleGroupView(muscle: muscleGroup, equipment: equipment)
                    }
                }
            }
        }
    }

}
