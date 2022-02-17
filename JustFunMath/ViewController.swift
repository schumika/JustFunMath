//
//  ViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 16.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvas: UIView!
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var outputStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureBoard()
    }
    
    func configureBoard() {
        let inputValues = [5, 2, 6, 3, 1]
        
        self.configure(views: inputStack.arrangedSubviews, with: inputValues.map { "\($0)" })
        self.configure(views: outputStack.arrangedSubviews, with: Array(repeating: "", count: inputValues.count))
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
            
        default:
            break;
        }
    }
}

extension UIView {
    func isCloseEnoughToSnap(to targetView: UIView, in container: UIView) -> Bool {
        let movingViewFrame = self.convert(self.bounds, to: container)
        let targetViewFrame = targetView.convert(targetView.bounds, to: container)
        
        guard (abs(targetViewFrame.origin.x.distance(to: movingViewFrame.origin.x)) < 50.0) &&
                (abs(targetViewFrame.origin.y.distance(to: movingViewFrame.origin.y)) < 50.0) else { return false }
        
        
        return true
    }
    
    func closestViewForSnapping(views: [UIView], in contaier: UIView) -> UIView? {
        return views.first { self.isCloseEnoughToSnap(to: $0, in: contaier)}
    }
}
