//
//  RoundLabelView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.02.2022.
//

import UIKit

class RoundLabelView: LazyNibLoaderView {
    @IBOutlet weak var label: TouchableLabel!
    
    func set(textColor: UIColor) {
        self.label.textColor = textColor
    }
    
    func set(text: String) {
        self.label.text = text
        self.label.backgroundColor = .clear
    }
    
    func configure(with text: String, panGestureRecognizer: UIPanGestureRecognizer) {
        self.set(text: text)
        
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(panGestureRecognizer)
        self.label.backgroundColor = UIColor(white: 1.0, alpha: 0.11)
    }
}

class TouchableLabel: UILabel {
    var isMoving: Bool = false
}
