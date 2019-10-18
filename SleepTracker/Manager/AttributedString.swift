//
//  AttributedString.swift
//  SleepTracker
//
//  Created by Vikhyath on 06/03/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class AttributedString {
    
    static func getAttributedString(str: String) -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: str)
        let font = UIFont.systemFont(ofSize: 35)
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
        ]
        
        let attribute2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]
        guard let index = str.firstIndex(of: "h") else { return attributedText }
        let startIndex = str.distance(from: str.startIndex, to: index)
        attributedText.addAttributes(attributes1, range: NSRange(location: 0, length: str.count))
        attributedText.addAttributes(attribute2, range: NSRange(location: startIndex + 1, length: str.count - startIndex - 1))
        
        return attributedText
    }
    
    static func getString(str: String) -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: str)
        let font = UIFont.systemFont(ofSize: 35)
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
        ]
        
        let attribute2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white
        ]
        
        guard let index = str.lastIndex(of: " ") else { return attributedText }
        
        let length = str.distance(from: index, to: str.endIndex)
        attributedText.addAttributes(attributes1, range: NSRange(location: 0, length: str.count))
        attributedText.addAttributes(attribute2, range: NSRange(location: index.encodedOffset , length: length))
        
        return attributedText
    }
}


