//
//  VWheelLayer.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import CoreGraphics
import UIKit

class VWheelLayer: CALayer {
  
    var preferences: VConfiguration.WheelPreferences?
    var slices:[Slice] = []
    var mainFrame: CGRect!
    init(frame:CGRect, slices: [Slice], preferences: VConfiguration.WheelPreferences?) {
        self.slices = slices
        self.preferences = preferences
        super.init()
        self.frame = frame
        self.backgroundColor = UIColor.clear.cgColor
        self.contentsScale = UIScreen.main.scale
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        updateSizes()
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateSizes()
    }
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        drawCanvas(with: mainFrame)
        UIGraphicsPopContext()
    }
    override var masksToBounds: Bool {
        set {
            
        }
        get {
            return false
        }
    }
    func drawCanvas(with frame: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let startPositionOffsetDegree = preferences?.startPosition.startAngleOffset ?? 0
        let offSetDegree: CGFloat = (sliceDegree / 2)
        var rotation:CGFloat = -sliceDegree + startPositionOffsetDegree
        let start:CGFloat = -offSetDegree
        let end = sliceDegree - offSetDegree
        self.slices.enumerated().forEach { (index,element) in
            rotation += sliceDegree
            self.drawSlice(withIndex: index,
                           in: context,
                           forSlice: element,
                           rotation:rotation,
                           start: start,
                           end: end)
        }
        let circleFrame = UIBezierPath(ovalIn: frame)
        preferences?.circlePreferences.strokeColor.setStroke()
        circleFrame.lineWidth = preferences?.circlePreferences.strokeWidth ?? 0
        circleFrame.stroke()
        if let imageAnchor = preferences?.imageAnchor {
            var _rotation: CGFloat = -sliceDegree + startPositionOffsetDegree
            for index in 0..<slices.count {
                _rotation += sliceDegree
                self.drawAnchorImage(in: context,
                                     imageAnchor: imageAnchor,
                                     isCentered: false,
                                     rotation: _rotation,
                                     index: index,
                                     radius: radius,
                                     sliceDegree: sliceDegree,
                                     rotationOffset: rotationOffset)
            }
        }
        if let imageAnchor = preferences?.centerImageAnchor {
            var _rotation: CGFloat = -sliceDegree + startPositionOffsetDegree
            for index in 0..<slices.count {
                _rotation += sliceDegree
                self.drawAnchorImage(in: context,
                                     imageAnchor: imageAnchor,
                                     isCentered: true,
                                     rotation: _rotation,
                                     index: index,
                                     radius: radius,
                                     sliceDegree: sliceDegree,
                                     rotationOffset: rotationOffset)
            }
        }
        context.endTransparencyLayer()
        context.restoreGState()
    }
}
extension VWheelLayer: SliceDrawing {}
extension VWheelLayer: SpinningAnimatable {}
