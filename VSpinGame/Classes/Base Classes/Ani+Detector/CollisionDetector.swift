//
//  RotationProgress.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

class CollisionDetector {
    weak var animationObjectLayer: CALayer?
    var onCollision: ((_ progress: Double?) -> Void)?
    private var updater: CADisplayLink?
    private lazy var collisionCalculator = CollisionCalculator()
    private lazy var continuousCollisionCalculator = ContinuousCollisionCalculator()
    init(animationObjectLayer: CALayer?, onCollision: ((_ progress: Double?) -> Void)? = nil) {
        self.animationObjectLayer = animationObjectLayer
        self.onCollision = onCollision
        updater = CADisplayLink(target: self, selector: #selector(screenRefresh))
        updater?.add(to: .current, forMode: .default)
        updater?.isPaused = true
    }
    func prepareWithContinuousAnimation(sliceDegree: CGFloat, rotationDegreeOffset: CGFloat, fullRotationDegree: CGFloat, speed: CGFloat, speedAcceleration: CGFloat) {
        reset()
        continuousCollisionCalculator.calculateCollisionInterval(sliceDegree: sliceDegree, rotationDegreeOffset: rotationDegreeOffset, fullRotationDegree: fullRotationDegree, speed: speed, speedAcceleration: speedAcceleration)
    }
    func prepare(sliceDegree: CGFloat, rotationDegree: CGFloat, rotationDegreeOffset: CGFloat, animationDuration: CFTimeInterval) {
        reset()
        collisionCalculator.calculateCollisionDegrees(sliceDegree: sliceDegree, rotationDegreeOffset: rotationDegreeOffset, rotationDegree: rotationDegree, animationDuration: animationDuration)
    }
    func start() {
        continuousCollisionCalculator.lastCollisionTime = CACurrentMediaTime()
        updater?.isPaused = false
    }
    func stop() {
        updater?.isPaused = true
    }
    private func reset() {
        continuousCollisionCalculator.reset()
        collisionCalculator.reset()
    }
    @objc
    private func screenRefresh(displaylink: CADisplayLink) {
        continuousCollisionCalculator.calculateCollisionsIfNeeded(timestamp: displaylink.timestamp, onCollision: { [weak self] progress in
            self?.onCollision?(progress)
        })
        let layerRotationZ = animationObjectLayer?.presentation()?.value(forKeyPath: "transform.rotation.z") as? Double
        collisionCalculator.calculateCollisionsIfNeeded(layerRotationZ: layerRotationZ, onCollision: { [weak self] progress in
            self?.onCollision?(progress)
        })
    }
}
