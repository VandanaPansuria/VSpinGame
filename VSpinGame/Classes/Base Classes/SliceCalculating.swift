//
//  SliceCalculating.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import CoreGraphics

protocol SliceCalculating {
    var slices: [Slice] { get set }
}
extension SliceCalculating {
    var sliceDegree: CGFloat {
        guard slices.count > 0 else {
            return 0
        }
        return 360.0 / CGFloat(slices.count)
    }
    var theta: CGFloat {
        return sliceDegree * .pi / 180.0
    }
    func computeRadian(from finishIndex:Int) -> CGFloat {
        return CGFloat(finishIndex) * sliceDegree
    }
    func segmentHeight(radius: CGFloat) -> CGFloat {
        return radius * (1 - cos(sliceDegree / 2 * CGFloat.pi / 180))
    }
}
