//
//  ComputationView.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class ComputationView: LazyNibLoaderView {
    
    @IBOutlet weak var term1Label: RoundLabelView!
    @IBOutlet weak var term2Label: RoundLabelView!
    @IBOutlet weak var operandLabel: RoundLabelView!
    @IBOutlet weak var equalsLabel: RoundLabelView!
    @IBOutlet weak var resultLabel: RoundLabelView!
    
    private var computation: Computation = .addition(t1: 1, t2: 1)
    
    func configure(with computation: Computation) {
        self.computation = computation
        
        self.term1Label.set(text: "\(computation.digit1)")
        self.term2Label.set(text: "\(computation.digit2)")
        self.operandLabel.set(text: "\(computation.operatorDescription)")
        self.equalsLabel.set(text: "=")
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        self.res.configure(with: "", panGestureRecognizer: panGestureRecognizer)
        self.resultLabel.set(textColor: .yellow)
        self.resultLabel.set(text: "")
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.resultLabel.addGestureRecognizer(doubleTapGesture)
    }
    
        @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            self.resultLabel.set(text: "")
        }
    
    var isCorrect: Bool {
        return "\(self.computation.correctResult)" == self.resultLabel.label.text
    }
}
