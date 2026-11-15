//
//  ConfettiView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ConfettiView: View {

    // MARK: - Types

    private struct Piece {
        let angle: Double
        let color: Color
        let size: CGFloat
        let speed: Double
        let spin: Double
    }

    // MARK: - Properties

    @State private var startDate = Date()

    private let pieces: [Piece] = (0..<Constants.Confetti.count).map { _ in
        Piece(
            angle: .random(in: -Double.pi * 0.9 ... -Double.pi * 0.1),
            color: Constants.Confetti.colors.randomElement() ?? Constants.Colors.yellow,
            size: .random(in: 6...11),
            speed: .random(in: 280...620),
            spin: .random(in: -8...8)
        )
    }

    // MARK: - UI

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                guard elapsed < Constants.Confetti.duration else { return }

                let origin = CGPoint(x: size.width / 2, y: size.height / 2)
                let fade = 1 - elapsed / Constants.Confetti.duration

                for piece in pieces {
                    let position = CGPoint(
                        x: origin.x + cos(piece.angle) * piece.speed * elapsed,
                        y: origin.y + sin(piece.angle) * piece.speed * elapsed
                            + Constants.Confetti.gravity * elapsed * elapsed / 2
                    )

                    var pieceContext = context
                    pieceContext.opacity = fade
                    pieceContext.translateBy(x: position.x, y: position.y)
                    pieceContext.rotate(by: .radians(piece.spin * elapsed))
                    pieceContext.fill(
                        Path(CGRect(x: -piece.size / 2, y: -piece.size / 4, width: piece.size, height: piece.size / 2)),
                        with: .color(piece.color)
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            startDate = Date()
        }
    }

}
