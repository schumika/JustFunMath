//
//  SortViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 16.02.2022.
//

import UIKit

class SortViewController: ExerciseViewController {
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var outputStack: UIStackView!
    
    var viewModel: SortViewModel! {
        didSet {
            guard self.isViewLoaded && (self.view.window != nil) else { return }
            
            self.configureBoard()
            self.getSourceAndDestinationViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.onMovingEnded = {
            let subviews = self.outputStack.arrangedSubviews.compactMap({ $0 as? SingleDigitView })
            self.sortCompleted = self.isFull(array: subviews)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getSourceAndDestinationViews()
    }
    
    func getSourceAndDestinationViews() {
        var allRoundedLabels = (self.inputStack.arrangedSubviews.compactMap({ $0 as? SingleDigitView }))
        allRoundedLabels.append(contentsOf: self.outputStack.arrangedSubviews.compactMap({ $0 as? SingleDigitView }))
        
        self.sourceViews = allRoundedLabels
        self.destinationViews = allRoundedLabels
    }
    
    func configureBoard() {
        self.sortCompleted = false
        
        let unsortedArray = self.viewModel.unsortedArray
        self.configure(views: inputStack.arrangedSubviews, with: unsortedArray.map { "\($0)" })
        self.configure(views: outputStack.arrangedSubviews, with: Array(repeating: "", count: unsortedArray.count))
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
            (numberView as? SingleDigitView)?.configure(with: "\(strings[ind])", panGestureRecognizer: panGestureRecognizer)
            (numberView as? SingleDigitView)?.clearsAfterMoving = true
        }
    }
    
    
    var sortCompleted = false {
        didSet {
            self.doneButton.isEnabled = sortCompleted
        }
    }
    
    @IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized, let movingLabel = (recognizer.view as? SingleDigitView)?.label else { return }
        
        // search for open spot in input stack
        let openSpot = inputStack.arrangedSubviews.first { (($0 as? SingleDigitView)?.label.text ?? "")?.isEmpty ?? false }
        guard let openSpot = (openSpot as? SingleDigitView)?.label else { return }
        
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
    
    override func doneButtonClicked(_ sender: Any) {
        guard let subviews = self.outputStack.arrangedSubviews as? [SingleDigitView] else { return }
        
        self.animate(isCorrect: self.viewModel.isSorted(output: self.extractedSolution(array: subviews))) {
            super.doneButtonClicked(sender)
            
            UIView.animate(withDuration: 0.5, delay: 1.0) {
                self.configureBoard()
                self.getSourceAndDestinationViews()
            }
        }
    }
    
    func isFull(array: [SingleDigitView]) -> Bool {
        array.first { ($0.label.text ?? "")?.isEmpty ?? false } == nil
    }
    
    func extractedSolution(array: [SingleDigitView]) -> [Int] {
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
    
    func closestViewForSnapping(views: [UIView], in contaier: UIView) -> SingleDigitView? {
        let labels = views.compactMap { $0 as? SingleDigitView }
        return labels.first { self.isCloseEnoughToSnap(to: $0, in: contaier) && ($0.label.text?.isEmpty ?? false )}
    }
}
