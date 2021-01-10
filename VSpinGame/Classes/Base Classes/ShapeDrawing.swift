//
//  ShapeDrawing.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol ShapeDrawing {}

extension ShapeDrawing {
    func drawRectangle(in context: CGContext, rotation: CGFloat, radius: CGFloat) {
        context.saveGState()
        context.rotate(by: rotation * CGFloat.pi/180)
        let rectangleHeight: CGFloat = 20
        let rectangle = CGRect(x: 0 - (rectangleHeight / 2), y: (-radius / 2) - (rectangleHeight / 2), width: rectangleHeight, height: rectangleHeight)
        context.addRect(rectangle)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
    }
    func drawLine(in context: CGContext, preferences: LinePreferences, start: CGFloat, and end: CGFloat, rotation: CGFloat, index: Int, topOffset: CGFloat, radius: CGFloat, margins: VConfiguration.Margins, contextPositionCorrectionOffsetDegree: CGFloat) {
        let strokeColor = preferences.strokeColor(for: index)
        context.saveGState()
        context.rotate(by: (rotation - contextPositionCorrectionOffsetDegree) * CGFloat.pi/180)
        let strokeWidth = preferences.height
        let yPosition = radius - preferences.verticalOffset - topOffset - margins.top
        let center = CGPoint(x: 0, y: 0)
        let path = CGMutablePath()
        path.addArc(center: center, radius: -yPosition, startAngle: Calc.torad(start), endAngle: Calc.torad(end), clockwise: false)
        context.setStrokeColor(strokeColor.cgColor)
        context.setFillColor(UIColor.clear.cgColor)
        context.setLineWidth(strokeWidth)
        context.addPath(path)
        context.strokePath()
        context.restoreGState()
    }
}
