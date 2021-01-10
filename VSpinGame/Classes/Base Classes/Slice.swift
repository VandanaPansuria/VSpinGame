//
//  Slice.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation

import UIKit
public struct Slice {
    public var contents: [ContentType]
    public var backgroundColor: UIColor?
    public var backgroundImage: UIImage?
    public var objArray : Array<Any>
    public init(contents: [ContentType],
                backgroundColor: UIColor? = nil,
                backgroundImage: UIImage? = nil, objArray : Array<Any>) {
        self.contents = contents
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.objArray = objArray
    }
}
extension Slice {
    public enum ContentType {
        case assetImage(name: String, preferences: ImagePreferences)
        case image(image: UIImage, preferences: ImagePreferences)
        case text(text: String, preferences: TextPreferences)
        case line(preferences: LinePreferences)
    }
}
