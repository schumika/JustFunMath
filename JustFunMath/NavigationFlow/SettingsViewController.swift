//
//  SettingsViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 18.02.2022.
//

import UIKit

protocol SettingsViewControllerProtocol: NSObjectProtocol {
    func menuViewControllerDidSelectProceed(with level: ExerciseLevel, type: ExerciseType)
}

struct SettingsScreenViewModel {
    var sections: [SettingsSectionViewModel]
    let settings: ExerciseSettings
    
    init(settings: ExerciseSettings) {
        self.settings = settings
        self.sections = [SettingsSectionViewModel(title: "Nivel",
                                                  options: settings.allLevels.map { $0.rawValue },
                                                  selectedOptionIndex: ExerciseLevel.allCases.firstIndex(of: settings.level) ?? 0),
                         SettingsSectionViewModel(title: "Tip de exercitiu",
                                                  options: settings.allTypes.map { $0.rawValue },
                                                  selectedOptionIndex: ExerciseType.allCases.firstIndex(of: settings.type) ?? 0)]
    }
    
    mutating func updateSection(at ind: Int, with section: SettingsSectionViewModel) {
        sections[ind] = section
    }
}

struct SettingsSectionViewModel {
    var title: String
    var options: [String]
    var selectedOptionIndex: Int
    
    mutating func setSelectedOptionIndex(_ ind: Int) {
        self.selectedOptionIndex = ind
    }
}

class SettingsViewController: BoardViewController {
    var viewModel: SettingsScreenViewModel!
    
    weak var delegate: SettingsViewControllerProtocol?
    
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
    
    @IBAction func proceedClicked(_ sender: Any) {
        let levelSection = self.viewModel.sections[0]
        let selectedLevel = self.viewModel.settings.allLevels[levelSection.selectedOptionIndex]
        
        let typeSection = self.viewModel.sections[1]
        let selectedType = self.viewModel.settings.allTypes[typeSection.selectedOptionIndex]
        
        self.delegate?.menuViewControllerDidSelectProceed(with: selectedLevel, type: selectedType)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let sectionData = self.viewModel.sections[indexPath.section]
        
        cell.backgroundColor = .clear
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 40)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text =  sectionData.options[indexPath.row]
        cell.selectionStyle = .none
        
        let isSelected = sectionData.selectedOptionIndex == indexPath.row
        
        cell.textLabel?.textColor = isSelected ? .yellow : .white
        cell.accessoryType = isSelected ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: .init(origin: .init(x: 0, y: 0), size: .init(width: tableView.frame.width, height: 40)))
        label.text = self.viewModel.sections[section].title
        label.backgroundColor = .clear
        label.textColor = .cyan
        label.font = UIFont(name: "Chalkduster", size: 25)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var section = self.viewModel.sections[indexPath.section]
        section.setSelectedOptionIndex(indexPath.row)
        self.viewModel.updateSection(at: indexPath.section, with: section)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
