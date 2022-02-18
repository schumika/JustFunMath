//
//  SortViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 16.02.2022.
//

import UIKit

class SortViewController: BoardViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var rightWrongLabel: UILabel!
    @IBOutlet weak var outputStack: UIStackView!
    
    var sortAscending = false
    var unsortedArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureBoard()
    }
    
    func configureBoard() {
        self.unsortedArray = SortArrayDataProvider(level: 1).unsortedArray()
        self.sortAscending = Bool.random()
        
        self.sortCompleted = false
        
        self.configure(views: inputStack.arrangedSubviews, with: unsortedArray.map { "\($0)" })
        self.configure(views: outputStack.arrangedSubviews, with: Array(repeating: "", count: unsortedArray.count))
        self.titleLabel.text = "Ordoneaza \(self.sortAscending ? "CRESCATOR" : "DESCRESCATOR") sirul de numere"
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
    @IBAction func doneButtonClicked(_ sender: Any) {
        guard let subviews = self.outputStack.arrangedSubviews as? [RoundLabelView] else { return }
        
        let sortedArray = self.sortAscending ? self.unsortedArray.sorted() : self.unsortedArray.sorted().reversed()
        
        if sortedArray == self.extractedSolution(array: subviews) {
            print("Corect")
            self.rightWrongLabel.isHidden = false
            
            UIView.animate(withDuration: 5.0) {
                self.rightWrongLabel.transform.scaledBy(x: 0.5, y: 0.5)
            } completion: { _ in
                self.rightWrongLabel.isHidden = true
                
                UIView.animate(withDuration: 0.5, delay: 1.0) {
                    self.configureBoard()
                }
            }
        } else {
            print("Gresit")
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
