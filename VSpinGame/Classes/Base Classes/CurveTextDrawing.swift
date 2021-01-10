//
//  CurveTextDrawing.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol CurveTextDrawing {}

extension CurveTextDrawing {
    func centreArcPerpendicular(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, clockwise: Bool, preferedSize: CGSize) {
        
        context.scaleBy(x: 1, y: -1)
        
        let characters: [String] = str.map { String($0) }
        let l = characters.count
        let attributes = [NSAttributedString.Key.font: font]
        var arcs: [CGFloat] = []
        var totalArc: CGFloat = 0
        for i in 0 ..< l {
            arcs += [chordToArc(characters[i].size(withAttributes: attributes).width, radius: r)]
            totalArc += arcs[i]
        }
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2
        var thetaI = theta - direction * totalArc / 2
        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            centre(text: characters[i], context: context, radius: r, angle: thetaI, colour: c, font: font, slantAngle: thetaI + slantCorrection, preferedWidth: preferedSize.width)
            thetaI += direction * arcs[i] / 2
        }
    }
    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }
    
    func centre(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, slantAngle: CGFloat, preferedWidth: CGFloat) {
        let attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font]
        context.saveGState()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        context.rotate(by: -slantAngle)
        let offset = str.size(withAttributes: attributes)
        context.translateBy(x: -offset.width / 2, y: -offset.height / 2)
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        context.restoreGState()
    }
}
