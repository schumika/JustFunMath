//
//  ComparisonView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.05.2022.
//

import UIKit

class ComparisonView: LazyNibLoaderView, ExerciseViewProtocol {
    @IBOutlet weak var term1View: UIView!
    @IBOutlet weak var term2View: UIView!
    @IBOutlet weak var operandLabel: SingleDigitView!
    
    var exerciseDeterminationBlock: (String) -> Bool = { _ in false }
    
    var maxWidth: CGFloat = 0.5
    var resultLabels: [SingleDigitView] {
        [self.operandLabel]
    }
    
    func configure(with comparison: ExerciseProtocol, isSingleDigit: Bool) {
        // removing existing subviews
        self.exerciseDeterminationBlock = comparison.isCorrect
        
        self.term1View.subviews.forEach { $0.removeFromSuperview() }
        self.term2View.subviews.forEach { $0.removeFromSuperview() }
        
        let ViewType = isSingleDigit ? SingleDigitView.self : TwoDigitView.self
        
        // adding new subviews
        self.term1View.addTextConfigurableView(ViewType: ViewType, withText: "\(comparison.term1)")
        self.term2View.addTextConfigurableView(ViewType: ViewType, withText: "\(comparison.term2)")
        
        
        self.operandLabel.set(text: "")
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.operandLabel.addGestureRecognizer(doubleTapGesture)
    }
    
    @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        self.operandLabel.set(text: "")
    }
    
    var isCorrect: Bool {
        self.exerciseDeterminationBlock(self.operandLabel.label.text ?? "")
    }
}

extension UIView {
    func addTextConfigurableView(ViewType: LazyNibLoaderView.Type, withText text: String) {
        guard let label = ViewType.init() as? (UIView & TextConfigurable) else { return }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: label.maxWidth).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.maxHeight).isActive = true
        
        label.set(text: text)
    }
}
