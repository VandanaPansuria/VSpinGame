//
//  UIImage+Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

extension UIImage {
    func withTintColor(_ tintColor: UIColor) -> UIImage {
        var image: UIImage = self
        if #available(iOS 13.0, *) {
            image = self.withTintColor(tintColor, renderingMode: .alwaysTemplate)
        } else {
            // Fallback
            image = self.withColor(tintColor)
        }
        return image
    }
    
    private func withColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        color.setFill()
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return colored
    }
}
