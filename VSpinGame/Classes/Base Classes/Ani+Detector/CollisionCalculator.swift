//
//  CollisionCalculator.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

class CollisionCalculator {
    private var collisionDegrees: [Double] = []
    private var currentCollisionIndex: Int = 0
    private var rotationCount: Int = 0
    private var totalRotationDegree: Double = 0
    private var lastRotationDegree: Double?
    private var rotationDirectionOffset: CGFloat {
        return 1
    }
    func calculateCollisionDegrees(sliceDegree: CGFloat, rotationDegreeOffset: CGFloat, rotationDegree: CGFloat, animationDuration: CFTimeInterval) {
        let sectorsCount = (rotationDegree / sliceDegree)
        for index in 0..<Int(sectorsCount) {
            let degree = (rotationDegreeOffset + (CGFloat(index) * sliceDegree))
            collisionDegrees.append(Double(degree))
        }
    }
    func calculateCollisionsIfNeeded(layerRotationZ: Double?, onCollision: ((_ progress: Double?) -> Void)? = nil) {
        guard collisionDegrees.count > 0 else { return }
        guard let rotationZ = layerRotationZ else { return }
        guard currentCollisionIndex < collisionDegrees.count else { return }
        let rotationOffset = rotationZ * Double(rotationDirectionOffset) * 180.0 / .pi
        let currentRotationDegree = rotationOffset >= 0 ? rotationOffset : 360 + rotationOffset
        totalRotationDegree = Double(rotationCount * 360) + currentRotationDegree
        let currentCollisionDegree = collisionDegrees[currentCollisionIndex]
        if currentCollisionDegree < totalRotationDegree {
            var nextCollisionIndex = currentCollisionIndex + 1
            guard currentCollisionIndex < collisionDegrees.count else {
                currentCollisionIndex = nextCollisionIndex
                let progress: Double = Double(currentCollisionIndex / collisionDegrees.count)
                onCollision?(progress)
                return
            }
            let nextCollisionDegrees = collisionDegrees[currentCollisionIndex+1..<collisionDegrees.count]
            for nextCollisionDegree in nextCollisionDegrees {
                if nextCollisionDegree < totalRotationDegree {
                    nextCollisionIndex += 1
                } else {
                    break
                }
            }
            currentCollisionIndex = nextCollisionIndex
            let progress: Double = Double(currentCollisionIndex) / Double(collisionDegrees.count)
            onCollision?(progress)
        }
        if lastRotationDegree ?? 0 > currentRotationDegree {
            rotationCount += 1
        }
        lastRotationDegree = currentRotationDegree
    }
    func reset() {
        collisionDegrees = []
        currentCollisionIndex = 0
        rotationCount = 0
        totalRotationDegree = 0
        lastRotationDegree = nil
    }
}
