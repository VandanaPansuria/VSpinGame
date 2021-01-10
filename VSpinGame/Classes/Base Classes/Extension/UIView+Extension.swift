//
//  UIView+Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

extension UIView
{
    func setAnchorPoint(anchorPoint:CGPoint)
    {
        let layer = self.layer
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
}
