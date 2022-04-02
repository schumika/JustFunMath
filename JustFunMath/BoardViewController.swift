//
//  BoardViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 18.02.2022.
//

import UIKit



class BoardViewController: UIViewController {
    @IBOutlet weak var canvas: UIView!
}

class ExerciseViewController: BoardViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: ExerciseViewControllerProtocol?
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        self.delegate?.didSelectSettings()
    }
}

@objc protocol ExerciseViewControllerProtocol {
    func didSelectSettings()
}
