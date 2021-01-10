//
//  CollisionEffect.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import UIKit

public struct CollisionEffect {
    
    public var force: Double
    public var angle: CGFloat
    public init(force: Double = 10, angle: CGFloat = 30) {
        self.force = force
        self.angle = angle
    }
}
