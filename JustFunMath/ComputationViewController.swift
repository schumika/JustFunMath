//
//  ComputationViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class ComputationViewController: ExerciseViewController {
    @IBOutlet weak var outputStack: UIStackView!
    @IBOutlet weak var computationsStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.configureBoard()
    }

    var computationsCompleted: Bool = false {
        didSet {
            self.doneButton.isEnabled = computationsCompleted
        }
    }
    var computations: [Computation] = []

    var allDigitLabels: [RoundLabelView] = []

    func configureBoard() {
        self.computationsCompleted = false
        self.computations = [ComputationGenerator.simpleAddition(), ComputationGenerator.simpleSubstraction()]

        self.allDigitLabels.removeAll()

        for (ind1, substack) in self.outputStack.arrangedSubviews.enumerated() {
            guard let subviews = (substack as? UIStackView)?.arrangedSubviews else { return }
            for (ind2, subview) in  subviews.enumerated() {

                guard let roundLabelView = subview as? RoundLabelView else { return }
                let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

                roundLabelView.configure(with: "\((ind1 == 0 ? 0 : 5) + ind2)", panGestureRecognizer: panGestureRecognizer)
                allDigitLabels.append(roundLabelView)
            }
        }
        
        let computationViews = self.computationsStack.arrangedSubviews.compactMap { $0 as? ComputationView }
        for (ind, subview) in computationViews.enumerated() {
            subview.configure(with: self.computations[ind])
        }

    }

    var panTrackingPoint = CGPoint.zero
    var panStartingPoint = CGPoint.zero
    var selectedView: RoundLabelView?

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let movingLabel = recognizer.view as? TouchableLabel else { return }

        let allSubviews = self.allDigitLabels
        let resultLabels = self.computationsStack.arrangedSubviews.compactMap { ($0 as? ComputationView)?.resultLabel }

        switch recognizer.state {
        case .began:
            self.panTrackingPoint = movingLabel.center
            self.panStartingPoint = movingLabel.center

            movingLabel.isMoving = true
            self.selectedView = allSubviews.first { $0.label.isMoving == true }

        case .changed:
            let translation = recognizer.translation(in: self.view)
            let panOffsetTransform = CGAffineTransform( translationX: translation.x, y: translation.y)

            movingLabel.center = self.panTrackingPoint.applying(panOffsetTransform)

        case .ended:
            if let targetView = movingLabel.closestViewForSnapping(views: resultLabels, in: self.canvas) as? RoundLabelView,
               (targetView.label.text?.isEmpty ?? false) {
                targetView.set(text: movingLabel.text ?? "")
//                self.selectedView?.set(text: "")
            }

            UIView.animate(withDuration: 0.2) {
                movingLabel.center = self.panStartingPoint
            }

            movingLabel.isMoving = false
            self.selectedView = nil
            self.panTrackingPoint = CGPoint.zero
            self.panStartingPoint = CGPoint.zero

//            guard let subviews = self.outputStack.arrangedSubviews as? [RoundLabelView] else { return }
            self.computationsCompleted = resultLabels.reduce(true, { partialResult, label in
                return partialResult && !(label.label.text?.isEmpty ?? false)
            })

        default:
            break;
        }
    }

    override func doneButtonClicked(_ sender: Any) {
        
        let isCorrect = self.computationsStack.arrangedSubviews
            .compactMap { $0 as? ComputationView }
            .reduce(true) { partialResult, view in
                return partialResult && view.isCorrect
            }
        
        self.animate(isCorrect: isCorrect, onCorrectCompletion: { [weak self] in
            self?.configureBoard()
        })
    }
}

class ComputationGenerator {
    
    static func simpleAddition() -> Computation {
        let (t1, t2) = ComputationGenerator.getSimpleAddition()
        return Computation.addition(t1: t1, t2: t2)
    }
    
    static func simpleSubstraction() -> Computation {
        let (t1, t2) = ComputationGenerator.getSimpleSubstraction()
        return Computation.substraction(t1: t1, t2: t2)
    }
    
    static func getSimpleAddition() -> (Int, Int) {
        while (true) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            if t1 + t2 < 10 {
                return (t1, t2)
            }
        }
    }
    
    static func getSimpleSubstraction() -> (Int, Int){
        while (true) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            if t2 <= t1 {
                return (t1, t2)
            }
        }
    }
    
    func getAddition() -> (Int, Int){
        var found = false
        while (!found) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            let t3 = Int.random(in: 0...9)
            let t4 = Int.random(in: 0...9)
            
            if t2 + t4 < 10 && t1 + t3 < 10 {
                
                let x1 = t1 * 10 + t2
                let x2 = t3 * 10 + t4
                if x1 + x2 < 100 {
                    found = true
                    return (x1, x2)
                }
            }
        }
    }

    func getSubstraction() -> (Int, Int) {
        var found = false
        while (!found) {
            let t1 = Int.random(in: 0...9)
            let t2 = Int.random(in: 0...9)
            
            let t3 = Int.random(in: 0...9)
            let t4 = Int.random(in: 0...9)
            
            if t2 >= t4 && t1 >= t3 {
                
                let x1 = t1 * 10 + t2
                let x2 = t3 * 10 + t4
                if x1 - x2 > 0 {
                    found = true
                    return (x1, x2)
                }
            }
        }
    }
}
