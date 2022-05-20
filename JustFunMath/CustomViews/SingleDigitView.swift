//
//  RoundLabelView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.02.2022.
//

import UIKit

protocol TextConfigurable {
    func set(text: String)
    func set(textColor: UIColor)
    var maxWidth: CGFloat { get }
    var maxHeight: CGFloat { get }
    var resultLabels: [SingleDigitView] { get }
    var numberValue: Int { get }
}

extension TextConfigurable {
    func set(text: String) {}
    var maxHeight: CGFloat { 70.0 }
}

class SingleDigitView: LazyNibLoaderView, TextConfigurable {
    @IBOutlet weak var label: TouchableLabel!
    var maxWidth: CGFloat { 60.0 }
    
    func set(textColor: UIColor) {
        self.label.textColor = textColor
    }
    
    func set(text: String) {
        self.label.text = text
        self.label.backgroundColor = .clear
    }
    
    var resultLabels: [SingleDigitView] {
        return [self]
    }
    
    func configure(with text: String, panGestureRecognizer: UIPanGestureRecognizer) {
        self.set(text: text)
        
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(panGestureRecognizer)
        self.label.backgroundColor = UIColor(white: 1.0, alpha: 0.11)
    }
    
    var clearsAfterMoving: Bool = false
    
    var numberValue: Int {
        return Int(self.label.text ?? "") ?? 0
    }
}

class TouchableLabel: UILabel {
    var isMoving: Bool = false
}
