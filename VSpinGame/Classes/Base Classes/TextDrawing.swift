//
//  TextDrawing.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol TextDrawing: CurveTextDrawing {}

extension TextDrawing {
    private func availableTextRect(yPosition: CGFloat, preferences: TextPreferences, topOffset: CGFloat, radius: CGFloat, sliceDegree: CGFloat, margins: VConfiguration.Margins) -> [CGRect] {
        let maxHeight = abs(yPosition) - margins.bottom
        let maxLines = preferences.numberOfLines == 0 ? Int((maxHeight / (preferences.font.pointSize + preferences.spacing)).rounded(.up)) : preferences.numberOfLines
        var textRects: [CGRect] = []
        for line in 1...maxLines {
            let heightOffset = preferences.font.pointSize * CGFloat(line)
            let spacing = line == 1 ? 0 : preferences.spacing * CGFloat(line)
            let bottomYPosition = -(radius - preferences.verticalOffset - topOffset - heightOffset - spacing)
            let width = min(preferences.maxWidth, self.width(forYPosition: bottomYPosition,
                                                             sliceDegree: sliceDegree,
                                                             leftMargin: margins.left,
                                                             rightMargin: margins.right))
            let textRect = CGRect(x: 0, y: 0, width: width, height: preferences.font.pointSize)
            textRects.append(textRect)
        }
        return textRects
    }
    private func width(forYPosition yPosition: CGFloat, sliceDegree: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat) -> CGFloat {
        let width = Calc.circularSegmentHeight(radius: -yPosition, from: sliceDegree) - leftMargin - rightMargin
        return width
    }
}

extension TextDrawing {
    func drawCurved(text: String, in context:CGContext, preferences: TextPreferences, rotation: CGFloat, index: Int, topOffset: CGFloat, radius: CGFloat, sliceDegree: CGFloat, contextPositionCorrectionOffsetDegree: CGFloat, margins: VConfiguration.Margins) -> CGFloat {
        let textColor = preferences.color(for: index)
        let yPosition = -(radius - preferences.verticalOffset - topOffset - margins.top) + preferences.font.pointSize / 2
        let textRects = availableTextRect(yPosition: yPosition,
                                          preferences: preferences,
                                          topOffset: topOffset,
                                          radius: radius,
                                          sliceDegree: sliceDegree,
                                          margins: margins)
        let multilineString = text.split(font: preferences.font, lineWidths: textRects.map({ $0.width }), lineBreak: preferences.lineBreakMode)
        let height = preferences.font.pointSize * CGFloat(multilineString.count) + preferences.spacing * max(0, CGFloat(multilineString.count - 1))
        for index in 0..<multilineString.count {
            let string = multilineString[index]
            let spacing = index == 0 ? 0 : preferences.spacing * CGFloat(index)
            let textRect = textRects[index]
            let yPos = yPosition + textRect.height * CGFloat(index) + spacing
            context.saveGState()
            let angleRotation = -(rotation + contextPositionCorrectionOffsetDegree) * CGFloat.pi/180
            self.centreArcPerpendicular(text: string,
                                        context: context,
                                        radius: -yPos,
                                        angle: angleRotation,
                                        colour: textColor,
                                        font: preferences.font,
                                        clockwise: preferences.flipUpsideDown,
                                        preferedSize: textRect.size)
            context.restoreGState()
        }
        return height + preferences.verticalOffset
    }
    func drawHorizontal(text: String, in context:CGContext, preferences: TextPreferences, rotation: CGFloat, index: Int, topOffset: CGFloat, radius: CGFloat, sliceDegree: CGFloat, margins: VConfiguration.Margins) -> CGFloat {
        let textFontAttributes = preferences.textAttributes(for: index)
        let yPosition = -(radius - preferences.verticalOffset - topOffset - margins.top)
        var textRects = availableTextRect(yPosition: yPosition,
                                          preferences: preferences,
                                          topOffset: topOffset,
                                          radius: radius,
                                          sliceDegree: sliceDegree,
                                          margins: margins)
        if !preferences.flipUpsideDown {
            textRects.reverse()
        }
        var multilineString = text.split(font: preferences.font, lineWidths: textRects.map({ $0.width }), lineBreak: preferences.lineBreakMode)
        let height = preferences.font.pointSize * CGFloat(multilineString.count) + preferences.spacing * max(0, CGFloat(multilineString.count - 1))
        if !preferences.flipUpsideDown {
            multilineString.reverse()
            textRects.reverse()
        }
        for index in 0..<multilineString.count {
            let string = multilineString[index]
            let spacing = index == 0 ? 0 : preferences.spacing * CGFloat(index)
            let textRect = textRects[index]
            let xPos = -(textRect.width / 2) - preferences.horizontalOffset
            let yPos = yPosition + textRect.height * CGFloat(index) + spacing
            context.saveGState()
            context.rotate(by: rotation * CGFloat.pi/180)
            context.translateBy(x: xPos, y: yPos)
            if !preferences.flipUpsideDown {
                context.rotate(by: Calc.flipRotation)
                context.translateBy(x: -textRect.width, y: -textRect.height)
            }
            string.draw(in: CGRect(x: 0, y: 0, width: textRect.width, height: CGFloat.infinity), withAttributes: textFontAttributes)
            context.restoreGState()
        }
        return height + preferences.verticalOffset
    }
    func drawVertical(text: String, in context: CGContext, preferences: TextPreferences, rotation: CGFloat, index: Int, topOffset: CGFloat, radius: CGFloat, sliceDegree: CGFloat, margins: VConfiguration.Margins) -> CGFloat {
        
        let textAttributes = preferences.textAttributes(for: index)
        let wordsCount = text.split(separator: " ".first!).count
        let maxWidth = Calc.circularSegmentHeight(radius: radius - preferences.verticalOffset - topOffset, from: sliceDegree)
        let maxLinesInSlice = (maxWidth / (preferences.font.pointSize + preferences.spacing)).rounded(.up)
        var availableTextRects: [CGRect] = []
        for line in 1..<Int(maxLinesInSlice) {
            let spacing = line > 1 ? preferences.spacing : 0
            let _height = preferences.font.pointSize * CGFloat(line) + preferences.spacing * (CGFloat(line) - 1)
            let _maxCircularSegmentHeight = _height - margins.top - margins.bottom
            let _bottomRadiusOffset = max(margins.bottom, Calc.radius(circularSegmentHeight: _maxCircularSegmentHeight, from: sliceDegree))
            let _availableWidthInSlice = radius - preferences.verticalOffset - topOffset - _bottomRadiusOffset
            let _currentLineSpace = (_availableWidthInSlice * _height)
            let _nextHeight = preferences.font.pointSize * CGFloat(line + 1) + preferences.spacing * (CGFloat(line))
            let _nextMaxCircularSegmentHeight = _nextHeight + spacing - margins.top - margins.bottom
            let _nextBottomRadiusOffset = max(margins.bottom, Calc.radius(circularSegmentHeight: _nextMaxCircularSegmentHeight, from: sliceDegree))
            let _nextAvailableWidthInSlice = radius - preferences.verticalOffset - topOffset - _nextBottomRadiusOffset
            let _nextLineSpace = (_nextAvailableWidthInSlice * _nextHeight)
            availableTextRects.append(CGRect(x: 0, y: 0, width: _availableWidthInSlice, height: _height))
            if _currentLineSpace > _nextLineSpace {
                break
            }
        }
        var multilineString: [String] = []
        var textRects: [CGRect] = []
        for index in 0..<availableTextRects.count {
            textRects = []
            multilineString = []
            let textRect = availableTextRects[index]
            let line = index + 1
            textRects = Array(repeating: CGRect(x: 0, y: 0, width: textRect.width, height: preferences.font.pointSize), count: line)
            multilineString = text.split(font: preferences.font, lineWidths: textRects.map({ min(preferences.maxWidth, $0.width) }), lineBreak: preferences.lineBreakMode)
            let _wordCount = max(multilineString.joined().split(separator: " ".first!).count, line)
            if wordsCount == _wordCount {
                // break
            }
        }
        let lineCount = multilineString.count
        let spacing = lineCount > 1 ? preferences.spacing : 0
        let contextWidth = preferences.font.pointSize * CGFloat(lineCount) + spacing * max(0, (CGFloat(lineCount) - 1))
        let contextHeight = textRects.first?.width ?? 0
        let yPosition = -(radius - preferences.verticalOffset - topOffset - margins.top)
        if !preferences.flipUpsideDown {
            multilineString.reverse()
        }
        for index in 0..<multilineString.count {
            let string = multilineString[index]
            let spacing = index == 0 ? 0 : preferences.spacing * CGFloat(index)
            let textRect = textRects[index]
            let xPos = textRect.height * CGFloat(index + 1) + spacing - contextWidth / 2 - preferences.horizontalOffset
            context.saveGState()
            context.rotate(by: rotation * CGFloat.pi/180)
            context.translateBy(x: xPos, y: yPosition)
            context.rotate(by: 90 * CGFloat.pi/180)
            if preferences.flipUpsideDown {
                context.rotate(by: Calc.flipRotation)
                context.translateBy(x: -textRect.width, y: -textRect.height)
            }
            string.draw(in: CGRect(x: 0, y: 0, width: textRect.width, height: CGFloat.infinity), withAttributes: textAttributes)
            context.restoreGState()
        }
        return contextHeight + preferences.verticalOffset
    }
}
