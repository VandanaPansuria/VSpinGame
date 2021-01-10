//
//  Array+Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }
        return self[index]
    }
}
