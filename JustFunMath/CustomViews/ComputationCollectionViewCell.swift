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
