//
//  LazyNibLoader.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 17.02.2022.
//

import UIKit

class LazyNibLoaderView: UIView {
    @IBOutlet var containerView: UIView!

    func setup() {
        guard self.containerView == nil else { return }

        Bundle.main.loadNibNamed("\(type(of: self))", owner: self)
        //UIUtils.addCustomSubview(self.containerView, flushToSuper: self)
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        
        let views: [String : Any] = ["super": self, "subview": self.containerView!]
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|",
                                                         options: NSLayoutConstraint.FormatOptions(),
                                                         metrics: nil, views: views)
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|",
                                                                      options: NSLayoutConstraint.FormatOptions(),
                                                                      metrics: nil, views: views))
        self.addConstraints(constraints)
        
        self.backgroundColor = .clear
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview != nil {
            self.setup()
        }
    }
}
