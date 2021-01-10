//
//  ImagePreferences.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

public struct ImagePreferences {
    public var preferredSize: CGSize
    public var horizontalOffset: CGFloat = 0
    public var verticalOffset: CGFloat
    public var flipUpsideDown: Bool = false
    public var backgroundColor: UIColor? = nil
    public var tintColor: UIColor? = nil
    public init(preferredSize: CGSize,verticalOffset: CGFloat = 0) {
        self.preferredSize = preferredSize
        self.verticalOffset = verticalOffset
    }
}
