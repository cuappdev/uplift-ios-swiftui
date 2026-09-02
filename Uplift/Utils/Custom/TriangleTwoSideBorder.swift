//
//  TriangleTwoSideBorder.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TriangleTwoSideBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        return path
    }
}
