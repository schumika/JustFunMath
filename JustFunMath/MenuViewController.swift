//
//  MenuViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 18.02.2022.
//

import UIKit

class MenuViewController: BoardViewController {
    
    var dificulties = ["Clasa 0", "Clasa I"]
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var selectedDifficulty = 0
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        guard let nextViewController =  UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SortViewController") as? SortViewController else { return }
        
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.viewModel = SortViewModel.generate(for: self.selectedDifficulty)
        
        self.present(nextViewController, animated:true, completion:nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        guard cell == nil else { self.configure(cell: cell!, at: indexPath) ; return cell! }
        
        let newCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        newCell.backgroundColor = .clear
        newCell.textLabel?.backgroundColor = .clear
        newCell.textLabel?.textColor = .white
        newCell.textLabel?.font = UIFont(name: "Chalkduster", size: 40)
        
        newCell.textLabel?.textAlignment = .center
        newCell.textLabel?.text =  self.dificulties[indexPath.row]
        newCell.selectionStyle = .none
        
        self.configure(cell: newCell, at: indexPath)
        
        return newCell
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let isSelected = self.selectedDifficulty == indexPath.row
        
        cell.textLabel?.textColor = isSelected ? .yellow : .white
        cell.textLabel?.backgroundColor = isSelected ? UIColor(white: 0.5, alpha: 0.5) : .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDifficulty = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
