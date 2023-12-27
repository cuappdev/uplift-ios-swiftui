//
//  DividerLine.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A line used to separate views.
struct DividerLine: View {

    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Constants.Colors.gray01)
    }

}

#Preview {
    DividerLine()
}
