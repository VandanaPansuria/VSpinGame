//
//  TextPreferences.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

public struct TextPreferences {
    
    public var font: UIFont
    public var textColorType: VConfiguration.ColorType
    public var horizontalOffset: CGFloat = 0
    public var verticalOffset: CGFloat
    public var flipUpsideDown: Bool = true
    public var isCurved: Bool = true
    public var orientation: Orientation = .horizontal
    public var lineBreakMode: LineBreakMode = .clip
    public var numberOfLines: Int = 1
    public var spacing: CGFloat = 3
    public var alignment: NSTextAlignment = .center
    public var maxWidth: CGFloat = .greatestFiniteMagnitude
    public init(textColorType: VConfiguration.ColorType,font: UIFont,verticalOffset: CGFloat = 0) {
        self.textColorType = textColorType
        self.font = font
        self.verticalOffset = verticalOffset
    }
}

public extension TextPreferences {
    enum Orientation {
        case horizontal
        case vertical
    }
}

public extension TextPreferences {
    enum LineBreakMode {
        case clip
        case truncateTail
        case wordWrap
        case characterWrap
        var systemLineBreakMode: NSLineBreakMode {
            switch self {
            case .clip:
                return .byClipping
            case .truncateTail:
                return .byTruncatingTail
            case .wordWrap:
                return .byWordWrapping
            case .characterWrap:
                return  .byCharWrapping
            }
        }
    }
}
extension TextPreferences {
    func color(for index: Int) -> UIColor {
        var color: UIColor = .clear
        switch self.textColorType {
        case .evenOddColors(let evenColor, let oddColor):
            color = index % 2 == 0 ? evenColor : oddColor
        case .customPatternColors(let colors, let defaultColor):
            color = colors?[index, default: defaultColor] ?? defaultColor
        }
        return color
    }
    func textAttributes(for index: Int) -> [NSAttributedString.Key:Any] {
        let textColor = self.color(for: index)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = alignment
        textStyle.lineBreakMode = lineBreakMode.systemLineBreakMode
        textStyle.lineSpacing = spacing
        let deafultAttributes:[NSAttributedString.Key: Any] =
            [.font: self.font,
             .foregroundColor: textColor,
             .paragraphStyle: textStyle ]
        return deafultAttributes
    }
}
