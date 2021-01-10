//
//  CollisionDelecting.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol CollisionProtocol {
    var sliceDegree: CGFloat? { get }
    var edgeCollisionDetectionOn: Bool { get }
    var centerCollisionDetectionOn: Bool { get }
    var edgeAnchorRotationOffset: CGFloat { get }
    var centerAnchorRotationOffset: CGFloat { get }
}

protocol CollisionDetectable: NSObject {
    var animationObject: SpinningAnimatorProtocol? { get set }
    var edgeCollisionDetector: CollisionDetector { get set }
    var centerCollisionDetector: CollisionDetector { get set }
}

extension CollisionDetectable {
    func startCollisionDetectorsIfNeeded() {
        startCollisionDetectorIfNeeded(type: .edge)
        startCollisionDetectorIfNeeded(type: .center)
    }
    func stopCollisionDetectorsIfNeeded() {
        stopCollisionDetectorIfNeeded(type: .edge)
        stopCollisionDetectorIfNeeded(type: .center)
    }
    func prepareAllCollisionDetectorsIfNeeded(with rotationDegree: CGFloat,
                                              animationDuration: CFTimeInterval,
                                              onEdgeCollision: ((_ progress: Double?) -> Void)? = nil,
                                              onCenterCollision: ((_ progress: Double?) -> Void)? = nil) {
        prepareCollisionDetectorIfNeeded(for: .edge,
                                         with: rotationDegree,
                                         animationDuration: animationDuration,
                                         onCollision: onEdgeCollision)
        prepareCollisionDetectorIfNeeded(for: .center,
                                         with: rotationDegree,
                                         animationDuration: animationDuration,
                                         onCollision: onCenterCollision)
    }
    func prepareCollisionDetectorIfNeeded(for type: CollisionType,
                                          with rotationDegree: CGFloat,
                                          animationDuration: CFTimeInterval,
                                          onCollision: ((_ progress: Double?) -> Void)? = nil) {
        
        guard isCollisionDetectorOn(for: type) else { return }
        guard let sliceDegree = self.animationObject?.sliceDegree else { return }
        let rotationOffset = rotationDegreeOffset(for: type)
        
        switch type {
        case .edge:
            edgeCollisionDetector.onCollision = onCollision
            edgeCollisionDetector.prepare(sliceDegree: sliceDegree, rotationDegree: rotationDegree, rotationDegreeOffset: rotationOffset, animationDuration: animationDuration)
        case .center:
            centerCollisionDetector.onCollision = onCollision
            centerCollisionDetector.prepare(sliceDegree: sliceDegree, rotationDegree: rotationDegree, rotationDegreeOffset: rotationOffset, animationDuration: animationDuration)
        }
    }
    func prepareAllCollisionDetectorsIfNeeded(with rotationDegree: CGFloat,
                                              speed: CGFloat,
                                              speedAcceleration: CGFloat,
                                              onEdgeCollision: ((_ progress: Double?) -> Void)? = nil,
                                              onCenterCollision: ((_ progress: Double?) -> Void)? = nil) {
        prepareCollisionDetectorIfNeeded(for: .edge,
                                         with: rotationDegree,
                                         speed: speed,
                                         speedAcceleration: speedAcceleration,
                                         onCollision: onEdgeCollision)
        prepareCollisionDetectorIfNeeded(for: .center,
                                         with: rotationDegree,
                                         speed: speed,
                                         speedAcceleration: speedAcceleration,
                                         onCollision: onCenterCollision)
    }
    func prepareCollisionDetectorIfNeeded(for type: CollisionType,
                                          with rotationDegree: CGFloat,
                                          speed: CGFloat,
                                          speedAcceleration: CGFloat,
                                          onCollision: ((_ progress: Double?) -> Void)? = nil) {
        
        guard isCollisionDetectorOn(for: type) else { return }
        guard let sliceDegree = self.animationObject?.sliceDegree else { return }
        let rotationOffset = rotationDegreeOffset(for: type)
        switch type {
        case .edge:
            edgeCollisionDetector.onCollision = onCollision
            edgeCollisionDetector.prepareWithContinuousAnimation(sliceDegree: sliceDegree, rotationDegreeOffset: rotationOffset,
                                                                 fullRotationDegree: rotationDegree,
                                                                 speed: speed,
                                                                 speedAcceleration: speedAcceleration)
        case .center:
            centerCollisionDetector.onCollision = onCollision
            centerCollisionDetector.prepareWithContinuousAnimation(sliceDegree: sliceDegree, rotationDegreeOffset: rotationOffset,
                                                                   fullRotationDegree: rotationDegree,
                                                                   speed: speed,
                                                                   speedAcceleration: speedAcceleration)
        }
    }
    func rotationDegreeOffset(for type: CollisionType) -> CGFloat {
        let sliceDegree = self.animationObject?.sliceDegree ?? 0
        switch type {
        case .edge:
            return (sliceDegree / 2) + (animationObject?.edgeAnchorRotationOffset ?? 0)
        case .center:
            return animationObject?.centerAnchorRotationOffset ?? 0
        }
    }
    func startCollisionDetectorIfNeeded(type: CollisionType) {
        guard isCollisionDetectorOn(for: type) else { return }
        switch type {
        case .edge:
            edgeCollisionDetector.start()
        case .center:
            centerCollisionDetector.start()
        }
    }
    func stopCollisionDetectorIfNeeded(type: CollisionType) {
        guard isCollisionDetectorOn(for: type) else { return }
        switch type {
        case .edge:
            edgeCollisionDetector.stop()
        case .center:
            centerCollisionDetector.stop()
        }
    }
    func isCollisionDetectorOn(for type: CollisionType) -> Bool {
        switch type {
        case .edge:
            return animationObject?.edgeCollisionDetectionOn ?? false
        case .center:
            return animationObject?.centerCollisionDetectionOn ?? false
        }
    }
}
