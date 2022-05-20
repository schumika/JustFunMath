//
//  ComputationView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 19.05.2022.
//

import UIKit

protocol ExerciseViewProtocol where Self: UIView {
    var maxWidth: CGFloat { get set }
    var resultLabels: [SingleDigitView] { get }
    var isCorrect: Bool { get }
    func configure(with computation: ExerciseProtocol, isSingleDigit: Bool)
}

class ComputationView: LazyNibLoaderView, ExerciseViewProtocol {
    @IBOutlet weak var term1View: UIView!
    @IBOutlet weak var term2View: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var operandLabel: SingleDigitView!
    @IBOutlet weak var equalsLabel: SingleDigitView!
    
    private var resultLabel: (UIView & TextConfigurable)!
    
    private var correctResult: Int = 0
    
    var maxWidth: CGFloat = 0.75
    var resultLabels: [SingleDigitView] {
        self.resultLabel.resultLabels
    }
    
    var exerciseDeterminationBlock: (String) -> Bool = { _ in false }
    
    func configure(with computation: ExerciseProtocol, isSingleDigit: Bool) {
        
        self.exerciseDeterminationBlock = computation.isCorrect
        self.maxWidth = isSingleDigit ? 0.5 : 0.75
        
        self.term1View.subviews.forEach { $0.removeFromSuperview() }
        self.term2View.subviews.forEach { $0.removeFromSuperview() }
        self.resultView.subviews.forEach { $0.removeFromSuperview() }
        
        let ViewType = isSingleDigit ? SingleDigitView.self : TwoDigitView.self
        
        // adding new subviews
        self.term1View.addTextConfigurableView(ViewType: ViewType, withText: "\(computation.term1)")
        self.term2View.addTextConfigurableView(ViewType: ViewType, withText: "\(computation.term2)")
        self.resultView.addTextConfigurableView(ViewType: ViewType, withText: "")
        
        if let resultLabel = self.resultView.subviews.compactMap({ $0 as? ( UIView & TextConfigurable) }).first {
            self.resultLabel = resultLabel
            self.resultLabel.set(textColor: .yellow)
        }
        
//        self.term1Label.set(text: "\(computation.term1)")
//        self.term2Label.set(text: "\(computation.term2)")
        self.operandLabel.set(text: "\(computation.operatorDescription)")
        self.equalsLabel.set(text: "=")
//        self.resultLabel.set(textColor: .yellow)
//        self.resultLabel.set(text: "")
        
//        self.correctResult = computation.correctResult
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.resultLabel.addGestureRecognizer(doubleTapGesture)
    }
    
        @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            self.resultLabel.set(text: "")
        }
    
    var isCorrect: Bool {
        self.exerciseDeterminationBlock(String(self.resultLabel.numberValue))
    }
}
