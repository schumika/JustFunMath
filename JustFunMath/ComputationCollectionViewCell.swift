//
//  ComputationCollectionViewCell.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 04.04.2022.
//

import UIKit

class ComputationCollectionViewCell: UICollectionViewCell {
    var computationView: ComputationView =  ComputationView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(computationView)
        
        computationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.computationView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.computationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        self.computationView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        self.computationView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
    }
    
    func configure(with computation: Computation) {
        self.computationView.configure(with: computation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
