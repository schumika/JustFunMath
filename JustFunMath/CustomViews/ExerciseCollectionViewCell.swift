//
//  ExerciseCollectionViewCell.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import UIKit

class ExerciseCollectionViewCell<T: ExerciseViewProtocol>: UICollectionViewCell {
    var exerciseView: T =  T()
    
    private var widthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(exerciseView)
        
        exerciseView.translatesAutoresizingMaskIntoConstraints = false
        
        self.exerciseView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.exerciseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        self.exerciseView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.widthConstraint = self.exerciseView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: exerciseView.maxWidth)
        self.widthConstraint.isActive = true
    }
    
    func configure(with computation: ExerciseProtocol, isSingleDigit: Bool) {
        self.widthConstraint.isActive = false
        self.widthConstraint = self.exerciseView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: isSingleDigit ? 0.5 : 0.75)
//        self.widthConstraint = self.exerciseView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: exerciseView.maxWidth)
        self.widthConstraint.isActive = true
        self.exerciseView.configure(with: computation, isSingleDigit: isSingleDigit)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
