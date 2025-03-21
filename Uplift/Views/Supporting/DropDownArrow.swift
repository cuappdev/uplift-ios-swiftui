//
//  DropDownArrow.swift
//  Uplift
//
//  Created by Caitlyn Jin on 2/9/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// An arrow used for drop down menus.
struct DropDownArrow: View {

    @Binding var isExpanded: Bool

    var body: some View {
        Triangle()
            .fill(Constants.Colors.black)
            .rotationEffect(Angle(degrees: isExpanded ? 180 : 90))
            .frame(width: 10, height: 6)
    }

}
