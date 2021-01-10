//
//  UIFont+Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

extension UIFont {
    func sizeOfString(string: String, constrainedToWidth width: CGFloat) -> CGSize {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        return NSString(string: string).boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: options,
            attributes: [NSAttributedString.Key.font: self],
            context: nil
        ).size
    }
    func number(ofCharacters text: String, thatFit width: CGFloat, numberOfLines: Int = 1) -> Int {
        let fontRef = CTFontCreateWithName(self.fontName as CFString, self.pointSize, nil)
        let attributes = [kCTFontAttributeName : fontRef]
        let attributedString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        let frameSetterRef = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        var characterFitRange: CFRange = CFRange()
        CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, CGSize(width: width, height: CGFloat(numberOfLines)*self.lineHeight), &characterFitRange)
        return Int(characterFitRange.length)
    }
}
