//
//  SortViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 16.02.2022.
//

import UIKit

class SortViewController: ExerciseViewController {
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var rightWrongLabel: UILabel!
    @IBOutlet weak var outputStack: UIStackView!
    
    var viewModel: SortViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureBoard()
    }
    
    func configureBoard() {
        self.sortCompleted = false
        
        self.configure(views: inputStack.arrangedSubviews, with: self.viewModel.unsortedArray.map { "\($0)" })
        self.configure(views: outputStack.arrangedSubviews, with: Array(repeating: "", count: self.viewModel.unsortedArray.count))
        self.titleLabel.text = self.viewModel.title
        
        for subview in outputStack.arrangedSubviews {
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            subview.addGestureRecognizer(doubleTapGesture)
        }
    }
    
    func configure(views: [UIView], with strings: [String]) {
        guard views.count == strings.count else { return }
        
        for (ind, numberView) in views.enumerated() {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            (numberView as? RoundLabelView)?.configure(with: "\(strings[ind])", panGestureRecognizer: panGestureRecognizer)
        }
    }
    
    
    var panTrackingPoint = CGPoint.zero
    var panStartingPoint = CGPoint.zero
    var selectedView: RoundLabelView?
    
    var sortCompleted = false {
        didSet {
            self.doneButton.isEnabled = sortCompleted
        }
    }
    
    @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized, let movingLabel = (recognizer.view as? RoundLabelView)?.label else { return }
        
        // search for open spot in input stack
        let openSpot = inputStack.arrangedSubviews.first { (($0 as? RoundLabelView)?.label.text ?? "")?.isEmpty ?? false }
        guard let openSpot = (openSpot as? RoundLabelView)?.label else { return }
        
        // move view to open spot
        UIView.animate(withDuration: 0.2) {
            let frame = openSpot.convert(openSpot.bounds, to: self.canvas)
            let targetFrame = movingLabel.convert(movingLabel.bounds, to: self.canvas)
            
            let translation = CGAffineTransform(translationX: frame.midX - targetFrame.midX, y: frame.midY - targetFrame.midY)
            movingLabel.center = movingLabel.center.applying(translation)

        } completion: { _ in
            openSpot.text = movingLabel.text
            movingLabel.text = ""
        }

    }

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let movingLabel = recognizer.view as? TouchableLabel else { return }
        
        var allSubviews = (self.inputStack.arrangedSubviews)
        allSubviews.append(contentsOf: self.outputStack.arrangedSubviews)
        
        switch recognizer.state {
        case .began:
            self.panTrackingPoint = movingLabel.center
            self.panStartingPoint = movingLabel.center
            
            movingLabel.isMoving = true
            self.selectedView = allSubviews.first { ($0 as? RoundLabelView)?.label.isMoving == true } as? RoundLabelView
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            let panOffsetTransform = CGAffineTransform( translationX: translation.x, y: translation.y)

            movingLabel.center = self.panTrackingPoint.applying(panOffsetTransform)
            
        case .ended:
            if let targetView = movingLabel.closestViewForSnapping(views: allSubviews, in: self.canvas) as? RoundLabelView,
               (targetView.label.text?.isEmpty ?? false) {
                targetView.set(text: movingLabel.text ?? "")
                self.selectedView?.set(text: "")
            }
            
            UIView.animate(withDuration: 0.2) {
                movingLabel.center = self.panStartingPoint
            }

            movingLabel.isMoving = false
            self.selectedView = nil
            self.panTrackingPoint = CGPoint.zero
            self.panStartingPoint = CGPoint.zero
            
            guard let subviews = self.outputStack.arrangedSubviews as? [RoundLabelView] else { return }
            self.sortCompleted = self.isFull(array: subviews)
            
        default:
            break;
        }
    }
    
    
    func animate(isCorrect: Bool, onCorrectCompletion: @escaping ()->()) {
        self.rightWrongLabel.text = self.viewModel.rightWrongTextLabel(isCorrect: isCorrect)
        self.rightWrongLabel.textColor = self.viewModel.rightWrongTextLabelColor(isCorrect: isCorrect)
        self.rightWrongLabel.isHidden = false
        
        UIView.animate(withDuration: 1.5) {
            self.rightWrongLabel.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        } completion: { _ in
            self.rightWrongLabel.transform = CGAffineTransform.identity
            self.rightWrongLabel.isHidden = true
            if isCorrect {
                onCorrectCompletion()
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        guard let subviews = self.outputStack.arrangedSubviews as? [RoundLabelView] else { return }
        
        self.animate(isCorrect: self.viewModel.isSorted(output: self.extractedSolution(array: subviews))) {
            UIView.animate(withDuration: 0.5, delay: 1.0) {
                self.configureBoard()
            }
        }
    }
    
    func isFull(array: [RoundLabelView]) -> Bool {
        array.first { ($0.label.text ?? "")?.isEmpty ?? false } == nil
    }
    
    func extractedSolution(array: [RoundLabelView]) -> [Int] {
        return array.compactMap { Int($0.label.text ?? "") }
    }
}

extension UIView {
    func isCloseEnoughToSnap(to targetView: UIView, in container: UIView) -> Bool {
        let movingViewFrame = self.convert(self.bounds, to: container)
        let targetViewFrame = targetView.convert(targetView.bounds, to: container)
        
        guard (abs(targetViewFrame.origin.x.distance(to: movingViewFrame.origin.x)) < 85.0) &&
                (abs(targetViewFrame.origin.y.distance(to: movingViewFrame.origin.y)) < 70.0) else { return false }
        
        
        return true
    }
    
    func closestViewForSnapping(views: [UIView], in contaier: UIView) -> UIView? {
        return views.first { self.isCloseEnoughToSnap(to: $0, in: contaier)}
    }
}
