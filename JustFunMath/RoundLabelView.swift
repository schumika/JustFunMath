//
//  RoundLabelView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.02.2022.
//

import Foundation
import UIKit

class RoundLabelView: LazyNibLoaderView {
    @IBOutlet weak var label: TouchableLabel!
    
    func set(text: String) {
        self.label.text = text
    }
    
    func configure(with text: String, panGestureRecognizer: UIPanGestureRecognizer) {
        self.set(text: text)
        
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(panGestureRecognizer)
    }
}

class TouchableLabel: UILabel {
    var isMoving: Bool = false
}
