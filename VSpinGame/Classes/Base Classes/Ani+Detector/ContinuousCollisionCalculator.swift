//
//  ContinuousCollisionCalculator.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

class ContinuousCollisionCalculator {
    var lastCollisionTime: CFTimeInterval = 0
    private var CollisionInterval: CFTimeInterval?
    private var currentCollisionIndex: Int = 0
    var rotationDegreeOffset: CGFloat = 0
    func calculateCollisionInterval(sliceDegree: CGFloat, rotationDegreeOffset: CGFloat, fullRotationDegree: CGFloat, speed: CGFloat, speedAcceleration: CGFloat) {
        self.rotationDegreeOffset = rotationDegreeOffset
        CollisionInterval = CFTimeInterval(sliceDegree / (fullRotationDegree * speed * speedAcceleration))
    }
    func calculateCollisionsIfNeeded(timestamp: CFTimeInterval, onCollision: ((_ progress: Double?) -> Void)? = nil) {
        guard let collisionInterval = self.CollisionInterval else { return }
        let interval = currentCollisionIndex == 0 ? collisionInterval - Double(rotationDegreeOffset) : collisionInterval
        if lastCollisionTime + interval < timestamp {
            lastCollisionTime = timestamp
            currentCollisionIndex += 1
            onCollision?(nil)
        }
    }
    func reset() {
        CollisionInterval = nil
        currentCollisionIndex = 0
    }
}
