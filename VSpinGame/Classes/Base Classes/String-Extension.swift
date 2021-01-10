//
//  String-Extension.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import Foundation
import UIKit
extension String {
    func split(font: UIFont, lineWidths: [CGFloat], lineBreak: TextPreferences.LineBreakMode, splitCharacter: String = " ") -> [String] {
        var linedStrings: [String] = []
        let splitCharacterWidth = splitCharacter.width(by: font)
        var words = self.split(separator: splitCharacter.first!)
        var lastWordMinimumSize = CGFloat.greatestFiniteMagnitude
        if let lastWord = words.last {
            lastWordMinimumSize = String(lastWord.suffix(4)).width(by: font)
        }
        var latestAddedWord = 0
        for index in stride(from: 0, to: lineWidths.count, by: 1) {
            var linedString = ""
            var availableWidthInLine = lineWidths[index]
            for wordIndex in latestAddedWord..<words.count {
                guard latestAddedWord != words.count else { break }
                let isFirstWordInLine = linedString.count < 1
                let word = String(words[wordIndex])
                let wordWidth = isFirstWordInLine ? word.width(by: font) : word.width(by: font) + splitCharacterWidth
                let isWordFit = availableWidthInLine > wordWidth
                if isWordFit {
                    linedString = isFirstWordInLine ? linedString + word : linedString + splitCharacter + word
                    availableWidthInLine -= wordWidth
                    latestAddedWord = wordIndex + 1
                } else {
                    guard lineBreak != .wordWrap else { continue }
                    if lineBreak == .characterWrap {
                        let croppedWord = word.crop(by: isFirstWordInLine ? availableWidthInLine : availableWidthInLine - splitCharacterWidth, font: font)
                        let wordSecondPart = word.dropFirst(croppedWord.count)
                        if isFirstWordInLine {
                            linedString = linedString + croppedWord
                        } else {
                            linedString = linedString + splitCharacter + croppedWord
                        }
                        words.insert(wordSecondPart, at: wordIndex+1)
                        availableWidthInLine = 0
                        latestAddedWord = wordIndex + 1
                    } else {
                        if isFirstWordInLine {
                            var croppedWord = word.crop(by: availableWidthInLine, font: font)
                            if lineBreak == .truncateTail {
                                croppedWord.replaceLastCharactersWithDots()
                            }
                            linedString += croppedWord
                            availableWidthInLine = 0
                            latestAddedWord = wordIndex + 1
                        } else {
                            let isLatestLine = lineWidths.count - 1 == index
                            guard isLatestLine else { continue }
                            guard availableWidthInLine >= splitCharacterWidth + lastWordMinimumSize else { continue }
                            var croppedWord = word.crop(by: availableWidthInLine, font: font)
                            guard croppedWord.count > 3 else { continue }
                            if lineBreak == .truncateTail {
                                croppedWord.replaceLastCharactersWithDots()
                            }
                            linedString += splitCharacter + croppedWord
                            availableWidthInLine = 0
                            latestAddedWord = wordIndex + 1
                        }
                    }
                }
            }
            guard linedString.count > 0 else { continue }
            linedStrings.append(linedString)
        }
        return linedStrings
    }
    func crop(by width: CGFloat, font: UIFont) -> String {
        var croppedText = ""
        var textWidth: CGFloat = 0
        for element in self {
            let characterString = String(element)
            let letterSize = characterString.size(withAttributes: [.font: font])
            textWidth += letterSize.width
            guard textWidth < width else { break }
            croppedText += characterString
        }
        return croppedText
    }
    mutating func replaceLastCharactersWithDots(count: Int = 3) {
        var string = self
        let dots = Array.init(repeating: ".", count: count).joined()
        let start = string.index(string.endIndex, offsetBy: -count)
        let end = string.endIndex
        string.replaceSubrange(start..<end, with: dots)
        self = string
    }
    func width(by font: UIFont) -> CGFloat {
        var textWidth: CGFloat = 0
        for element in self {
            let characterString = String(element)
            let letterSize = characterString.size(withAttributes: [.font: font])
            textWidth += letterSize.width
        }
        return textWidth + 1
    }
    func linesCount(for font: UIFont, spacing: CGFloat) -> Int {
        let width = self.width(by: font)
        return max(1, Int((width / (font.pointSize + spacing)).rounded(.down)))
    }
}
