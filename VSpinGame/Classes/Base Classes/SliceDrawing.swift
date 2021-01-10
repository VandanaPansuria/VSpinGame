//
//  SliceDrawing.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import CoreGraphics
import UIKit

protocol SliceDrawing: WheelMathCalculating, SliceCalculating, TextDrawing, ImageDrawing, ShapeDrawing {}

extension SliceDrawing {
    var circularSegmentHeight: CGFloat {
        self.circularSegmentHeight(from: sliceDegree)
    }
    var margins: VConfiguration.Margins {
        var margins = self.preferences?.contentMargins ?? VConfiguration.Margins()
        margins.top = margins.top + (self.preferences?.circlePreferences.strokeWidth ?? 0) / 2
        margins.left = margins.left + (self.preferences?.circlePreferences.strokeWidth ?? 0)
        margins.right = margins.right + (self.preferences?.circlePreferences.strokeWidth ?? 0)
        margins.bottom = margins.bottom + (self.preferences?.circlePreferences.strokeWidth ?? 0) / 2
        return margins
    }
    var contextPositionCorrectionOffsetDegree: CGFloat {
        return -90
    }
}

extension SliceDrawing {
    
    func drawSlice(withIndex index:Int, in context:CGContext, forSlice slice: Slice, rotation:CGFloat, start: CGFloat, end: CGFloat) {
        context.saveGState()
        context.translateBy(x: rotationOffset, y: rotationOffset)
        self.drawPath(in: context,
                      backgroundColor: slice.backgroundColor,
                      backgroundImage: slice.backgroundImage,
                      start: start,
                      and: end,
                      rotation: rotation,
                      index: index)
        var topOffset: CGFloat = 0
        slice.contents.enumerated().forEach { (contentIndex, element) in
            switch element {
            case .text(let text, let preferences):
                topOffset += prepareDraw(text: text,
                                         in: context,
                                         preferences: preferences,
                                         rotation: rotation,
                                         index: index,
                                         topOffset: topOffset)
            case .assetImage(let imageName, let preferences):
                guard imageName != "", let image = UIImage(named: imageName) else {
                    topOffset += preferences.preferredSize.height + preferences.verticalOffset
                    break
                }
                self.drawImage(in: context,
                               image: image,
                               preferences: preferences,
                               rotation: rotation,
                               index: index,
                               topOffset: topOffset,
                               radius: radius,
                               margins: margins)
                topOffset += preferences.preferredSize.height + preferences.verticalOffset
            case .image(let image, let preferences):
                self.drawImage(in: context,
                               image: image,
                               preferences: preferences,
                               rotation: rotation,
                               index: index,
                               topOffset: topOffset,
                               radius: radius,
                               margins: margins)
                topOffset += preferences.preferredSize.height + preferences.verticalOffset
            case .line(let preferences):
                self.drawLine(in: context,
                              preferences: preferences,
                              start: start,
                              and: end,
                              rotation: rotation,
                              index: index,
                              topOffset: topOffset,
                              radius: radius,
                              margins: margins,
                              contextPositionCorrectionOffsetDegree: contextPositionCorrectionOffsetDegree)
                topOffset += preferences.height
            }
        }
        
        context.restoreGState()
    }
    private func drawPath(in context: CGContext, backgroundColor: UIColor?, backgroundImage: UIImage?, start: CGFloat, and end: CGFloat, rotation:CGFloat, index: Int) {
        context.saveGState()
        context.rotate(by: (rotation + contextPositionCorrectionOffsetDegree) * CGFloat.pi/180)
        var pathBackgroundColor = backgroundColor
        if pathBackgroundColor == nil {
            switch preferences?.slicePreferences.backgroundColorType {
            case .some(.evenOddColors(let evenColor, let oddColor)):
                pathBackgroundColor = index % 2 == 0 ? evenColor : oddColor
            case .customPatternColors(let colors, let defaultColor):
                pathBackgroundColor = colors?[index, default: defaultColor] ?? defaultColor
            case .none:
                break
            }
        }
        
        let strokeColor = preferences?.slicePreferences.strokeColor
        let strokeWidth = preferences?.slicePreferences.strokeWidth
        let path = CGMutablePath()
        let center = CGPoint(x: 0, y: 0)
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: Calc.torad(start), endAngle: Calc.torad(end), clockwise: false)
        path.closeSubpath()
        context.setFillColor(pathBackgroundColor!.cgColor)
        context.addPath(path)
        context.drawPath(using: .fill)
        if let backgroundImage = backgroundImage {
            self.draw(backgroundImage: backgroundImage, in: context, clipPath: path)
        }
        if rotation != end {
            let startPoint = CGPoint(x: (radius * (cos((end)*(CGFloat.pi/180)))), y: (radius * (sin((start)*(CGFloat.pi/180)))))
            let endPoint = CGPoint(x: (radius * (cos((start)*(CGFloat.pi/180)))), y: (radius * (sin((end)*(CGFloat.pi/180)))))
            
            let line = UIBezierPath()
            line.move(to: center)
            line.addLine(to: startPoint)
            strokeColor?.setStroke()
            line.lineWidth = strokeWidth ?? 0
            line.stroke()
            
            let line2 = UIBezierPath()
            line2.move(to: center)
            line2.addLine(to: endPoint)
            strokeColor?.setStroke()
            line2.lineWidth = strokeWidth ?? 0
            line2.stroke()
        }
        
        context.restoreGState()
    }
    private func draw(backgroundImage: UIImage, in context: CGContext, clipPath: CGPath) {
        
        context.saveGState()
        context.addPath(clipPath)
        context.clip()
        context.rotate(by: -contextPositionCorrectionOffsetDegree * CGFloat.pi/180)
        
        let aspectFillSize = CGSize.aspectFill(aspectRatio: backgroundImage.size, minimumSize: CGSize(width: radius, height: circularSegmentHeight))
        
        let position = CGPoint(x: -aspectFillSize.width / 2, y: -aspectFillSize.height)
        let rectangle = CGRect(x: position.x, y: position.y, width: aspectFillSize.width, height: aspectFillSize.height)
        
        switch preferences?.slicePreferences.backgroundImageContentMode {
        case .some(.bottom):
            
            backgroundImage.draw(at: position)
            
        default:
            backgroundImage.draw(in: rectangle)
        }
        
        context.restoreGState()
    }
    
    func prepareDraw(text: String, in context: CGContext, preferences: TextPreferences, rotation: CGFloat, index: Int, topOffset: CGFloat) -> CGFloat {
        switch preferences.orientation {
        case .horizontal:
            if preferences.isCurved {
                return self.drawCurved(text: text,
                                       in: context,
                                       preferences: preferences,
                                       rotation: rotation,
                                       index: index,
                                       topOffset: topOffset,
                                       radius: radius,
                                       sliceDegree: sliceDegree,
                                       contextPositionCorrectionOffsetDegree: contextPositionCorrectionOffsetDegree,
                                       margins: margins)
            } else {
                return self.drawHorizontal(text: text,
                                           in: context,
                                           preferences: preferences,
                                           rotation: rotation,
                                           index: index,
                                           topOffset: topOffset,
                                           radius: radius,
                                           sliceDegree: sliceDegree,
                                           margins: margins)
            }
        case .vertical:
            return self.drawVertical(text: text,
                                     in: context,
                                     preferences: preferences,
                                     rotation: rotation,
                                     index: index,
                                     topOffset: topOffset,
                                     radius: radius,
                                     sliceDegree: sliceDegree,
                                     margins: margins)
        }
    }
}
