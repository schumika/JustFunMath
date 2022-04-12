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
    
    var exerciseSettings = ExerciseSettings()
    
    override init() {
        self.splitViewController = UISplitViewController(style: .doubleColumn)
        
        super.init()
        
        self.computationViewController = self.getComputationViewController()
        self.settingsViewController = self.getSettingsViewController()
        self.sortingViewController = self.getSortScreen()
        
        var initialDetailViewController: ExerciseViewController
        if case .sorting = self.exerciseSettings.type {
            initialDetailViewController = self.sortingViewController
        } else {
            initialDetailViewController = self.computationViewController
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
        
        self.computationViewController.viewModel = ComputationsViewModel(level: self.exerciseSettings.level)
        self.sortingViewController.viewModel = SortViewModel(level: self.exerciseSettings.level)
        
        
//        guard typeChanged else { return }
        if case .sorting = type {
            self.showSortingDetailScreen()
        } else {
            self.showComputingDetailScreen()
        }
        
    }
}

