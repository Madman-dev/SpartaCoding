//
//  Extension.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/04.
//

import UIKit

// 차이점 구분
extension String {
    func strikethrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.thick.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
