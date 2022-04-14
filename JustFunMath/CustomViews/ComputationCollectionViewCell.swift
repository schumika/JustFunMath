//
//  ComputationCollectionViewCell.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import UIKit

class ComputationCollectionViewCell<T: ComputationViewProtocol>: UICollectionViewCell {
    var computationView: T =  T()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(computationView)
        
        computationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.computationView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.computationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        self.computationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.computationView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: computationView.maxWith).isActive = true
    }
    
    func configure(with computation: Computation) {
        self.computationView.configure(with: computation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class ComparisonCollectionViewCell<T: ComparisonViewProtocol>: UICollectionViewCell {
    var comparisonView: T =  T()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(comparisonView)
        
        comparisonView.translatesAutoresizingMaskIntoConstraints = false
        
        self.comparisonView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.comparisonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        self.comparisonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.comparisonView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: comparisonView.maxWith).isActive = true
    }
    
    func configure(with comparison: Comparison) {
        self.comparisonView.configure(with: comparison)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
