//
//  MenuViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 18.02.2022.
//

import UIKit

class MenuViewController: BoardViewController {
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        guard let nextViewController =  UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SortViewController") as? SortViewController else { return }
        
        nextViewController.modalPresentationStyle = .fullScreen
        
        self.present(nextViewController, animated:true, completion:nil)
    }
}
