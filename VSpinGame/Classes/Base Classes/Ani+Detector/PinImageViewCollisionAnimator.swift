//
//  PinImageCollisionAnimator.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import UIKit

class PinImageViewCollisionAnimator {
    var snapAnimator: UIDynamicAnimator?
    var snapBehavior: UISnapBehavior?
    weak var referenceView: UIView?
    weak var pinImageView: UIView?
    func prepare(referenceView: UIView, pinImageView: UIView) {
        self.pinImageView = pinImageView
        snapAnimator = UIDynamicAnimator(referenceView: referenceView)
        snapBehavior = UISnapBehavior(item: pinImageView, snapTo: pinImageView.center)
        snapAnimator?.addBehavior(snapBehavior!)
    }
    func movePin(force: Double, angle: CGFloat, position: VConfiguration.Position) {
        guard let pinImageView = self.pinImageView else { return }
        guard let snapBehavior = self.snapBehavior else { return }
        guard let snapAnimator = self.snapAnimator else { return }
        snapAnimator.removeBehavior(snapBehavior)
        UIView.animate(withDuration: 1 / force) {
            let theta = Calc.torad(angle * -1)
            pinImageView.transform = CGAffineTransform(rotationAngle: CGFloat(theta))
        } completion: { (success) in
            snapAnimator.addBehavior(snapBehavior)
        }
    }
    func movePinIfNeeded(collisionEffect: CollisionEffect?, position: VConfiguration.Position?) {
        guard let position = position else { return }
        guard let force = collisionEffect?.force else { return }
        guard let angle = collisionEffect?.angle else { return }
        guard force > 0 else { return }
        movePin(force: force, angle: angle, position: position)
    }
}

