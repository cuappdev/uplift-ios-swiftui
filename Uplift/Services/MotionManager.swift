//
//  MotionManager.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import CoreMotion
import Foundation

@MainActor
class MotionManager: ObservableObject {

    // MARK: - Properties

    @Published private(set) var tilt: CGSize = .zero

    private let manager = CMMotionManager()
    private var reference: CMAttitude?

    // MARK: - Functions

    func start() {
        guard manager.isDeviceMotionAvailable, !manager.isDeviceMotionActive else { return }

        reference = nil
        manager.deviceMotionUpdateInterval = Constants.Holographic.updateInterval
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let attitude = motion?.attitude else { return }

            if let reference {
                attitude.multiply(byInverseOf: reference)
            } else {
                reference = attitude.copy() as? CMAttitude
            }

            tilt = CGSize(
                width: max(-1, min(1, attitude.roll / Constants.Holographic.maxAngle)),
                height: max(-1, min(1, attitude.pitch / Constants.Holographic.maxAngle))
            )
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
        tilt = .zero
    }

}
