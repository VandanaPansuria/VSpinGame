//
//  Calc.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import CoreGraphics

struct Calc {
    static var flipRotation: CGFloat {
        return .pi
    }
    static func torad(_ f: CGFloat) -> CGFloat {
        return f * .pi / 180.0
    }
    static func circularSegmentHeight(radius: CGFloat, from degree: CGFloat) -> CGFloat {
        return 2 * radius * sin(degree / 2.0 * CGFloat.pi / 180)
    }
    static func radius(circularSegmentHeight: CGFloat, from degree: CGFloat) -> CGFloat {
        return circularSegmentHeight / (2 * sin(degree / 2.0 * CGFloat.pi / 180))
    }
}
