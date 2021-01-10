//
//  SpinningWheelAnimator.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import CoreGraphics
import UIKit

protocol SpinningAnimatorProtocol: class, CollisionProtocol  {
    var layerToAnimate: SpinningAnimatable? { get }
}

class SpinningWheelAnimator: NSObject {
    weak var animationObject: SpinningAnimatorProtocol?
    lazy var edgeCollisionDetector: CollisionDetector = CollisionDetector(animationObjectLayer: animationObject?.layerToAnimate)
    lazy var centerCollisionDetector: CollisionDetector = CollisionDetector(animationObjectLayer: animationObject?.layerToAnimate)
    var completionBlock: ((Bool) -> Void)?
    var currentRotationPosition: CGFloat?
    var rotationDirectionOffset: CGFloat {
        return 1
    }
    private var startedAnimationCount: Int = 0
    init(withObjectToAnimate animationObject: SpinningAnimatorProtocol) {
        super.init()
        self.animationObject = animationObject
    }
    func addIndefiniteRotationAnimation(speed: CGFloat = 1,
                                        onEdgeCollision: ((_ progress: Double?) -> Void)? = nil,
                                        onCenterCollision: ((_ progress: Double?) -> Void)? = nil) {
        
        let fullRotationDegree: CGFloat = 360
        let speedAcceleration: CGFloat = 1
        
        prepareAllCollisionDetectorsIfNeeded(with: fullRotationDegree,
                                             speed: speed,
                                             speedAcceleration: speedAcceleration,
                                             onEdgeCollision: onEdgeCollision,
                                             onCenterCollision: onCenterCollision)
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        let transformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        transformAnim.values   = [0, fullRotationDegree * speed * speedAcceleration * CGFloat.pi/180 * rotationDirectionOffset]
        transformAnim.keyTimes = [0, 1]
        transformAnim.duration = 1
        
        let rotationAnim : CAAnimationGroup = CAAnimationGroup(animations: [transformAnim], fillMode:fillMode)
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.delegate = self
        animationObject?.layerToAnimate?.add(rotationAnim, forKey:"starRotationIndefiniteAnim")
        
        startedAnimationCount += 1
        startCollisionDetectorsIfNeeded()
    }
    func addRotationAnimation(fullRotationsCount: Int,
                              animationDuration: CFTimeInterval,
                              rotationOffset: CGFloat = 0.0,
                              completionBlock: ((_ finished: Bool) -> Void)? = nil,
                              onEdgeCollision: ((_ progress: Double?) -> Void)? = nil,
                              onCenterCollision: ((_ progress: Double?) -> Void)? = nil) {
        
        self.currentRotationPosition = rotationOffset
        let rotation: CGFloat = CGFloat(fullRotationsCount) * 360.0 + rotationOffset
        prepareAllCollisionDetectorsIfNeeded(with: rotation,
                                             animationDuration: animationDuration,
                                             onEdgeCollision: onEdgeCollision,
                                             onCenterCollision: onCenterCollision)
        let transformAnim            = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        transformAnim.values         = [0, rotation * rotationDirectionOffset * CGFloat.pi/180]
        transformAnim.keyTimes       = [0, 1]
        transformAnim.duration       = animationDuration
        transformAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.0256, 0.874, 0.675, 1)
        transformAnim.fillMode = CAMediaTimingFillMode.forwards
        transformAnim.isRemovedOnCompletion = false
        transformAnim.delegate = self
        if completionBlock != nil {
            transformAnim.setValue("rotation", forKey:"animId")
            self.completionBlock = completionBlock
        }
        animationObject?.layerToAnimate?.add(transformAnim, forKey:"starRotationAnim")
        edgeCollisionDetector.animationObjectLayer = animationObject?.layerToAnimate
        centerCollisionDetector.animationObjectLayer = animationObject?.layerToAnimate
        startedAnimationCount += 1
        startCollisionDetectorsIfNeeded()
    }
    func stop() {
        self.animationObject?.layerToAnimate?.removeAllAnimations()
        stopCollisionDetectorsIfNeeded()
    }
}
// MARK: - CAAnimationDelegate
extension SpinningWheelAnimator: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = self.completionBlock,
           let animId = anim.value(forKey: "animId") as? String, animId == "rotation" {
            completionBlock(flag)
            self.completionBlock = nil
        }
        startedAnimationCount -= 1
        if startedAnimationCount < 1 {
            stopCollisionDetectorsIfNeeded()
        }
    }
}

// MARK: - CollisionDetectable
extension SpinningWheelAnimator: CollisionDetectable {}
