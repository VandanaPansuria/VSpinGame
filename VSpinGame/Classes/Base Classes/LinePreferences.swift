//
//  LinePreferences.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

public struct LinePreferences {
    public var height: CGFloat
    public var colorType: VConfiguration.ColorType
    public var verticalOffset: CGFloat
    public init(colorType: VConfiguration.ColorType,height: CGFloat = 1,verticalOffset: CGFloat = 0) {
        self.colorType = colorType
        self.height = height
        self.verticalOffset = verticalOffset
    }
}
extension LinePreferences {
    func strokeColor(for index: Int) -> UIColor {
        var strokeColor = UIColor.clear
        switch self.colorType {
        case .evenOddColors(let evenColor, let oddColor):
            strokeColor = index % 2 == 0 ? evenColor : oddColor
        case .customPatternColors(let colors, let defaultColor):
            strokeColor = colors?[index, default: defaultColor] ?? defaultColor
        }
        return strokeColor
    }
}
