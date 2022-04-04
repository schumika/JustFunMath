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
}

@objc protocol ExerciseViewControllerProtocol {
    func didSelectSettings()
    func didSelectDone()
}
