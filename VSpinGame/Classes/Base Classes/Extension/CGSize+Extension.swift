//
//  CGSize+Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit

extension CGSize {
    static func aspectFill(aspectRatio :CGSize, minimumSize: CGSize) -> CGSize {
        var minimumSize = minimumSize
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;
        if( mH > mW ) {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW > mH ) {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }
        return minimumSize;
    }
    func aspectFit(sizeImage:CGSize) -> CGRect {
        let imageSize:CGSize  = sizeImage
        let hfactor : CGFloat = imageSize.width/self.width
        let vfactor : CGFloat = imageSize.height/self.height
        let factor : CGFloat = max(hfactor, vfactor)
        let newWidth : CGFloat = imageSize.width / factor
        let newHeight : CGFloat = imageSize.height / factor
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        if newWidth > newHeight{
            y = (self.height - newHeight)/2
        }
        if newHeight > newWidth{
            x = (self.width - newWidth)/2
        }
        let newRect:CGRect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        return newRect
    }
}
