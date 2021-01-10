//
//  VConfiguration.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit
public struct VConfiguration {
    public var pinPreferences: PinImageViewPreferences?
    public var wheelPreferences: WheelPreferences
    public init(wheelPreferences: WheelPreferences,pinPreferences: PinImageViewPreferences? = nil) {
        self.wheelPreferences = wheelPreferences
        self.pinPreferences = pinPreferences
    }
}

public extension VConfiguration {
    struct WheelPreferences {
        public var circlePreferences: CirclePreferences
        public var slicePreferences: SlicePreferences
        public var startPosition: Position
        public var layerInsets: UIEdgeInsets = UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)
        public var contentMargins: Margins = Margins()
        public var imageAnchor: AnchorImage? = nil
        public var centerImageAnchor: AnchorImage? = nil
        var layerInsetsWithCircleWidth: UIEdgeInsets {
            let circleWidth = self.circlePreferences.strokeWidth
            return UIEdgeInsets(top: layerInsets.top - circleWidth,
                                left: layerInsets.left - circleWidth,
                                bottom: layerInsets.bottom - circleWidth,
                                right: layerInsets.right - circleWidth)
        }
        public init(circlePreferences: CirclePreferences,
                    slicePreferences: SlicePreferences,
                    startPosition: Position) {
            self.circlePreferences = circlePreferences
            self.slicePreferences = slicePreferences
            self.startPosition = startPosition
        }
    }
}

public extension VConfiguration {
    struct CirclePreferences {
        public var strokeWidth: CGFloat = 1
        public var strokeColor: UIColor = .black
        public init(strokeWidth: CGFloat = 1,
                    strokeColor: UIColor = .black) {
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
        }
    }
}

public extension VConfiguration {
    struct SlicePreferences {
        public var backgroundColorType: ColorType
        public var strokeWidth: CGFloat
        public var strokeColor: UIColor
        public var backgroundImageContentMode: ContentMode = .scaleAspectFill
        public init(backgroundColorType: ColorType,
                    strokeWidth: CGFloat = 1,
                    strokeColor: UIColor = .black) {
            self.backgroundColorType = backgroundColorType
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
        }
    }
}

public extension VConfiguration {
    struct PinImageViewPreferences {
        public var size: CGSize
        public var position: Position
        public var horizontalOffset: CGFloat
        public var verticalOffset: CGFloat
        public var backgroundColor: UIColor = .clear
        public var tintColor: UIColor? = nil
        public init(size: CGSize,
                    position: Position,
                    horizontalOffset: CGFloat = 0,
                    verticalOffset: CGFloat = 0) {
            self.size = size
            self.position = position
            self.horizontalOffset = horizontalOffset
            self.verticalOffset = verticalOffset
        }
    }
}

public extension VConfiguration {
    enum Position {
        case top
        case bottom
        case left
        case right
        var startAngleOffset: CGFloat {
            switch self {
            case .top:
                return 0
            case .right:
                return 90
            case .bottom:
                return 180
            case .left:
                return 270
            }
        }
    }
}

public extension VConfiguration {
    struct Margins {
        var left: CGFloat
        var right: CGFloat
        var top: CGFloat
        var bottom: CGFloat
        public init() {
            self.top = 3
            self.left = 2
            self.right = 2
            self.bottom = 3
        }
        public init(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat = 0) {
            self.top = top
            self.left = left
            self.right = right
            self.bottom = bottom
        }
    }
}

public extension VConfiguration {
    enum ColorType {
        case evenOddColors(evenColor: UIColor, oddColor: UIColor)
        case customPatternColors(colors: [UIColor]?, defaultColor: UIColor)
    }
}

public extension VConfiguration {
    struct AnchorImage {
        public var size: CGSize
        public var imageName: String
        public var rotationDegreeOffset: CGFloat = 0
        public var verticalOffset: CGFloat
        public var tintColor: UIColor? = nil
        public init(imageName: String,
                    size: CGSize,
                    verticalOffset: CGFloat = 0) {
            self.imageName = imageName
            self.size = size
            self.verticalOffset = verticalOffset
        }
    }
}

public extension VConfiguration {
    enum ContentMode {
        case scaleAspectFill
        case bottom
    }
}
