//
//  LabelHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/27/19.
//

import Foundation
import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func getSeparatedLines() -> [Any] {
        if self.lineBreakMode != NSLineBreakMode.byWordWrapping {
            self.lineBreakMode = .byWordWrapping
        }
        var lines = [Any]() /* capacity: 10 */
        let wordSeparators = CharacterSet.whitespacesAndNewlines
        var currentLine: String? = self.text
        let textLength: Int = self.text!.count
        var rCurrentLine = NSRange(location: 0, length: textLength)
        var rWhitespace = NSRange(location: 0, length: 0)
        var rRemainingText = NSRange(location: 0, length: textLength)
        var done: Bool = false
        while !done {
            // determine the next whitespace word separator position
            rWhitespace.location = rWhitespace.location + rWhitespace.length
            rWhitespace.length = textLength - rWhitespace.location
            rWhitespace = (self.text! as NSString).rangeOfCharacter(from: wordSeparators, options: .caseInsensitive, range: rWhitespace)
            if rWhitespace.location == NSNotFound {
                rWhitespace.location = textLength
                done = true
            }
            let rTest = NSRange(location: rRemainingText.location, length: rWhitespace.location - rRemainingText.location)
            let textTest: String = (self.text! as NSString).substring(with: rTest)
            let fontAttributes: [NSAttributedString.Key: Any]? = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
            let maxWidth = (textTest as NSString).size(withAttributes: fontAttributes).width
            if maxWidth > self.bounds.size.width {
                lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
                rRemainingText.location = rCurrentLine.location + rCurrentLine.length
                rRemainingText.length = textLength - rRemainingText.location
                continue
            }
            rCurrentLine = rTest
            currentLine = textTest
        }
        lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
        return lines
    }
    
    var lastLineWidth: CGFloat {
        let lines: [Any] = self.getSeparatedLines()
        if !lines.isEmpty {
            let lastLine: String = (lines.last as? String)!
            let fontAttributes: [NSAttributedString.Key: Any]? = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
            return (lastLine as NSString).size(withAttributes: fontAttributes).width
        }
        return 0
    }

}
