//
//  NewAppFlowCoordinator.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 11.04.2022.
//

import UIKit

class NewAppFlowCoordinator: NSObject, UISplitViewControllerDelegate {
    let splitViewController: UISplitViewController
    var computationViewController = ComputationViewController()
    var settingsViewController = SettingsViewController()
    var sortingViewController = SortViewController()
    var comparisonViewController = ComparisonViewController()
    
    var exerciseSettings = ExerciseSettings()
    
    override init() {
        self.splitViewController = UISplitViewController(style: .doubleColumn)
        
        super.init()
        
        self.computationViewController = self.getComputationViewController()
        self.settingsViewController = self.getSettingsViewController()
        self.sortingViewController = self.getSortScreen()
        self.comparisonViewController = self.getComparisonViewController()
        
        var initialDetailViewController: ExerciseViewController
        switch self.exerciseSettings.type {
        case .sorting: initialDetailViewController = self.sortingViewController
        case .computing: initialDetailViewController = self.computationViewController
        case .comparison: initialDetailViewController = self.comparisonViewController
        }
        
        self.configureSplitViewController(detailScreen: initialDetailViewController, masterScreen: self.settingsViewController)
    }
    
    func configureSplitViewController(detailScreen: UIViewController, masterScreen: SettingsViewController) {
        self.splitViewController.delegate = self
        let master = UINavigationController(rootViewController: masterScreen)
        let detail = UINavigationController(rootViewController: detailScreen)
        self.splitViewController.viewControllers = [master, detail]
        self.splitViewController.preferredDisplayMode = .secondaryOnly
        self.splitViewController.preferredSplitBehavior = .overlay
        self.splitViewController.presentsWithGesture = false
    }
    
    func showDetailScreen(_ vc: ExerciseViewController) {
        let master = UINavigationController(rootViewController: self.settingsViewController)
        let detail = UINavigationController(rootViewController: vc)
        self.splitViewController.viewControllers = [master, detail]
    }
    
    func showSortingDetailScreen() {
        self.showDetailScreen(self.sortingViewController)
    }
    
    func showComputingDetailScreen() {
        self.showDetailScreen(self.computationViewController)
    }
    
    func showComparisonDetailScreen() {
        self.showDetailScreen(self.comparisonViewController)
    }
    

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension NewAppFlowCoordinator {
    func getComputationViewController() -> ComputationViewController {
        let vc = ComputationViewController.getFromMainStoryboard() ?? ComputationViewController()
        vc.delegate = self
        vc.viewModel = .init(level: self.exerciseSettings.level)
        return vc
    }
    
    func getComparisonViewController() -> ComparisonViewController {
        let vc = ComparisonViewController.getFromMainStoryboard() ?? ComparisonViewController()
        vc.delegate = self
        vc.viewModel = .init(level: self.exerciseSettings.level)
        return vc
    }
    
    func getSettingsViewController() -> SettingsViewController {
        let vc = SettingsViewController.getFromMainStoryboard() ?? SettingsViewController()
        vc.viewModel = SettingsScreenViewModel(settings: self.exerciseSettings)
        vc.delegate = self
        return vc
    }
    
    func getSortScreen() -> SortViewController {
        let sortViewController = SortViewController.getFromMainStoryboard() ?? SortViewController()
        sortViewController.viewModel = SortViewModel(level: self.exerciseSettings.level)
        sortViewController.delegate = self
        return sortViewController
    }
    
}

extension NewAppFlowCoordinator: ExerciseViewControllerProtocol {
    func didSelectSettings() {
        self.splitViewController.show(.primary)
    }
    
    func didSelectDone() {}
}

extension NewAppFlowCoordinator: SettingsViewControllerProtocol {
    func menuViewControllerDidSelectProceed(with level: ExerciseLevel, type: ExerciseType) {
        self.splitViewController.hide(.primary)
        
//        let typeChanged = self.exerciseSettings.type != type
        self.exerciseSettings.update(with: level, type: type)
        
        self.computationViewController.viewModel = .init(level: self.exerciseSettings.level)
        self.sortingViewController.viewModel = .init(level: self.exerciseSettings.level)
        self.comparisonViewController.viewModel = .init(level: self.exerciseSettings.level)
        
        
//        guard typeChanged else { return }
        switch type {
        case .sorting: self.showSortingDetailScreen()
        case .computing: self.showComputingDetailScreen()
        case .comparison: self.showComparisonDetailScreen()
        }
    }
}

extension UIViewController {
    static func getFromMainStoryboard() -> Self? {
        UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
    }
}

