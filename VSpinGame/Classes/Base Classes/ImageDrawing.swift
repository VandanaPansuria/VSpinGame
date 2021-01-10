//
//  ImageDrawing.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

protocol ImageDrawing {}

extension ImageDrawing {
    
    func drawImage(in context: CGContext, image: UIImage, preferences: ImagePreferences, rotation: CGFloat, index: Int, topOffset: CGFloat, radius: CGFloat, margins: VConfiguration.Margins) {
        var image = image
        if let tintColor = preferences.tintColor {
            image = image.withTintColor(tintColor)
        }
        let flipAngle: CGFloat = preferences.flipUpsideDown ?  180 : 0
        context.saveGState()
        context.rotate(by: (flipAngle + rotation) * CGFloat.pi/180)
        let aspectRatioRect = preferences.preferredSize.aspectFit(sizeImage: image.size)
        let yPositionWithoutOffset = radius - preferences.verticalOffset - topOffset - margins.top
        let flipYOffset: CGFloat = preferences.flipUpsideDown ?  -radius + aspectRatioRect.height / 2  : 0
        let yPosition = yPositionWithoutOffset + flipYOffset
        
        let rectangle = CGRect(x: -(aspectRatioRect.size.width / 2), y: -yPosition, width: aspectRatioRect.size.width, height: aspectRatioRect.size.height)
        
        if let backgroundColor = preferences.backgroundColor {
            backgroundColor.setFill()
            context.fill(rectangle)
        }
        
        image.draw(in: rectangle, blendMode: .normal, alpha: 1)
        
        context.restoreGState()
    }
    func drawAnchorImage(in context: CGContext, imageAnchor: VConfiguration.AnchorImage, isCentered: Bool, rotation: CGFloat, index: Int, radius: CGFloat, sliceDegree: CGFloat, rotationOffset: CGFloat) {
        context.saveGState()
        context.translateBy(x: rotationOffset, y: rotationOffset)
        guard var image = UIImage(named: imageAnchor.imageName) else {
            context.restoreGState()
            return
        }
        if let tintColor = imageAnchor.tintColor {
            image = image.withTintColor(tintColor)
        }
        let centeredOffset: CGFloat = isCentered ? sliceDegree / 2 : 0
        let contextPositionCorrectionOffsetDegree: CGFloat = -sliceDegree / 2 + imageAnchor.rotationDegreeOffset + centeredOffset
        context.saveGState()
        context.rotate(by: (rotation + contextPositionCorrectionOffsetDegree) * CGFloat.pi/180)
        let yPosition: CGFloat = radius - imageAnchor.verticalOffset
        let xPosition: CGFloat = imageAnchor.size.width / 2
        let rectangle = CGRect(x: -xPosition, y: -yPosition, width: imageAnchor.size.width, height: imageAnchor.size.height)
        image.draw(in: rectangle, blendMode: .normal, alpha: 1)
        context.restoreGState()
        context.restoreGState()
    }
}
