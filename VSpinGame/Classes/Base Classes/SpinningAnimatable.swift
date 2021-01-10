//
//  SpinningAnimatable.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol SpinningAnimatable: CALayer {}

extension SpinningAnimatable {
    func updateLayerValues(forAnimationId identifier: String) {
        if identifier == "rotation"{
            self.updateValueFromPresentationLayer(forAnimation: self.animation(forKey: "starRotationAnim"))
        }
    }
    func removeAnimations(forAnimationId identifier: String) {
        if identifier == "rotation" {
            self.removeAnimation(forKey: "starRotationAnim")
        }
    }
    func removeIndefiniteAnimation() {
        self.removeAnimation(forKey: "starRotationIndefiniteAnim")
    }
}
