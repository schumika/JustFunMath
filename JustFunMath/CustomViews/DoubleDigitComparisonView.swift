//
//  DoubleDigitComparisonView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class DoubleDigitComparisonView: LazyNibLoaderView, ComparisonViewProtocol {
    
    @IBOutlet weak var term1Label: TwoDigitView!
    @IBOutlet weak var term2Label: TwoDigitView!
    @IBOutlet weak var operandLabel: RoundLabelView!
    
    private var correctResult: ComparisonResult = .equalTo
    
    var maxWith: CGFloat = 0.5
    var resultLabels: [RoundLabelView] {
        [self.operandLabel]
    }
    
    func configure(with comparison: Comparison) {
        
        self.term1Label.set(text: "\(comparison.term1)")
        self.term2Label.set(text: "\(comparison.term2)")
        self.operandLabel.set(text: "")
        
        self.correctResult = comparison.correctResult
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.operandLabel.addGestureRecognizer(doubleTapGesture)
    }
    
        @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            self.operandLabel.set(text: "")
        }
    
    var isCorrect: Bool {
        switch (self.correctResult, self.operandLabel.label.text) {
        case (.greaterThan, ">"): return true
        case (.lessThan, "<"): return true
        case (.equalTo, "="): return true
        default:
            return false
        }
    }
}
