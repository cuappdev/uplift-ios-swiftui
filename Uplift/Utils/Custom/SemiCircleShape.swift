//
//  SemiCircleShape.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A semi-circle shape.
struct SemiCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let r = rect.height / 2
        let center = CGPoint(x: rect.midX, y: rect.midY + r)
        var path = Path()
        path.addArc(
            center: center,
            radius: r,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 360),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
