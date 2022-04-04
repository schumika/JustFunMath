//
//  ExerciseViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import UIKit

class ExerciseViewController: BoardViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var rightWrongLabel: UILabel!
    
    weak var delegate: ExerciseViewControllerProtocol?
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        self.delegate?.didSelectSettings()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.delegate?.didSelectDone()
    }
    
    func rightWrongTextLabel(isCorrect: Bool) -> String {
        isCorrect ? "CORECT" : "GRESIT"
    }
    func rightWrongTextLabelColor (isCorrect: Bool) -> UIColor {
        isCorrect ? .green : .red
    }
    
    func animate(isCorrect: Bool, onCorrectCompletion: @escaping ()->()) {
        self.rightWrongLabel.text = self.rightWrongTextLabel(isCorrect: isCorrect)
        self.rightWrongLabel.textColor = self.rightWrongTextLabelColor(isCorrect: isCorrect)
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
    
    var panTrackingPoint = CGPoint.zero
    var panStartingPoint = CGPoint.zero
    var selectedView: RoundLabelView?
    
    var sourceViews: [RoundLabelView] = []
    var destinationViews: [RoundLabelView] = []
    
    var onMovingEnded: ()->() = { }

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let movingLabel = recognizer.view as? TouchableLabel else { return }

        switch recognizer.state {
        case .began:
            self.panTrackingPoint = movingLabel.center
            self.panStartingPoint = movingLabel.center

            movingLabel.isMoving = true
            self.selectedView = self.sourceViews.first { $0.label.isMoving == true }

        case .changed:
            let translation = recognizer.translation(in: self.view)
            let panOffsetTransform = CGAffineTransform( translationX: translation.x, y: translation.y)

            movingLabel.center = self.panTrackingPoint.applying(panOffsetTransform)

        case .ended:
            if let targetView = movingLabel.closestViewForSnapping(views: self.destinationViews, in: self.canvas),
               (targetView.label.text?.isEmpty ?? false) {
                targetView.set(text: movingLabel.text ?? "")
                if self.selectedView?.clearsAfterMoving ?? false {
                    self.selectedView?.set(text: "")
                }
            }

            UIView.animate(withDuration: 0.01) {
                movingLabel.center = self.panStartingPoint
            }

            movingLabel.isMoving = false
            self.selectedView = nil
            self.panTrackingPoint = CGPoint.zero
            self.panStartingPoint = CGPoint.zero
            
            self.onMovingEnded()

        default:
            break;
        }
    }

}

@objc protocol ExerciseViewControllerProtocol {
    func didSelectSettings()
    func didSelectDone()
}
