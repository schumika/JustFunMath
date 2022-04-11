//
//  TwoDigitView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 05.04.2022.
//

import UIKit


class TwoDigitView: LazyNibLoaderView {
    @IBOutlet weak var digit1Label: RoundLabelView!
    @IBOutlet weak var digit2Label: RoundLabelView!
    
    func configure(with text: String, panGestureRecognizer: UIPanGestureRecognizer) {
        
        if text.isEmpty {
            self.digit1Label.configure(with: "", panGestureRecognizer: panGestureRecognizer)
            self.digit2Label.configure(with: "", panGestureRecognizer: panGestureRecognizer)
        } else {
            if let digits = Int(text)?.digits, digits.count > 0 {
                self.digit2Label.configure(with: "\(digits[0])", panGestureRecognizer: panGestureRecognizer)
                
                if digits.count > 1 {
                    self.digit2Label.configure(with: "\(digits[1])", panGestureRecognizer: panGestureRecognizer)
                } else {
                    self.digit2Label.configure(with: "", panGestureRecognizer: panGestureRecognizer)
                }
                
            } else {
                self.digit1Label.configure(with: "", panGestureRecognizer: panGestureRecognizer)
                self.digit2Label.configure(with: "", panGestureRecognizer: panGestureRecognizer)
            }
        }
    }
    
    func set(text: String) {
        if text.isEmpty {
            self.digit1Label.set(text: "")
            self.digit2Label.set(text: "")
        } else {
            if let digits = Int(text)?.digits, digits.count > 0 {
//                self.digit2Label.set(text: "\(digits[0])")
//
//                if digits.count > 1 {
//                    self.digit1Label.set(text: "\(digits[1])")
//                } else {
//                    self.digit1Label.set(text: "")
//                }
                
                if digits.count == 2 {
                    self.digit1Label.set(text: "\(digits[0])")
                    self.digit2Label.set(text: "\(digits[1])")
                } else if digits.count == 1 {
                    self.digit1Label.set(text: "")
                    self.digit2Label.set(text: "\(digits[0])")
                } else {
                    self.digit1Label.set(text: "")
                    self.digit2Label.set(text: "")
                }
                
            } else {
                self.digit1Label.set(text: "")
                self.digit2Label.set(text: "")
            }
        }
    }
    
    var numberValue: Int {
        return self.digit1Label.numberValue * 10 + self.digit2Label.numberValue
    }
    
    func set(textColor: UIColor) {
        self.digit1Label.set(textColor: textColor)
        self.digit2Label.set(textColor: textColor)
    }
}

extension Int {
    var digits: [Int] {
        var arr: [Int] = []
        var number = self
        
        while number >= 10 {
            arr.insert(number % 10, at: 0)
            number = number / 10
        }
        
        arr.insert(number, at: 0)
        
        return arr
    }
}
