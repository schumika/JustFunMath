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
    var menuViewController = MenuViewController()
    
    var exerciseSettings = ExerciseSettings()
    
    override init() {
        self.splitViewController = UISplitViewController(style: .doubleColumn)
        
        super.init()
        
        self.computationViewController = self.getComputationViewController()
        self.menuViewController = self.getMenuViewController()
        self.configureSplitViewController(detailScreen: self.computationViewController, masterScreen: self.menuViewController)
    }
    
    func configureSplitViewController(detailScreen: ComputationViewController, masterScreen: MenuViewController) {
        self.splitViewController.delegate = self
        let master = UINavigationController(rootViewController: masterScreen)
        let detail = UINavigationController(rootViewController: detailScreen)
        self.splitViewController.viewControllers = [master, detail]
        self.splitViewController.preferredDisplayMode = .secondaryOnly
    }
    

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
//        if let nc = secondaryViewController as? UINavigationController {
//            if let topVc = nc.topViewController {
//                if let dc = topVc as? DetailVc {
//                    let hasDetail = Thing.noThing !== dc.thing
//                    return !hasDetail
//                }
//            }
//        }
        return true
    }
}

extension NewAppFlowCoordinator {
    func getComputationViewController() -> ComputationViewController {
        let vc = ComputationViewController.getFromMainStoryboard() ?? ComputationViewController()
        vc.delegate = self
        vc.viewModel = .init(settings: self.exerciseSettings)
        return vc
    }
    
    func getMenuViewController() -> MenuViewController {
        let vc = MenuViewController.getFromMainStoryboard() ?? MenuViewController()
        vc.delegate = self
        return vc
    }
    
}

extension NewAppFlowCoordinator: ExerciseViewControllerProtocol {
    func didSelectSettings() {
//        let screen = AppScreen.dificulties(self.getMenuViewController())
//        let vc = self.getMenuScreen(for: screen)
//        vc.modalPresentationStyle = .fullScreen
//
//        self.currentScreen.viewController?.present(vc, animated:true, completion:nil)
//        self.currentScreen = screen
        
        if self.splitViewController.isCollapsed {
            self.splitViewController.show(.primary)
        } else {
            self.splitViewController.hide(.primary)
        }
        
    }
    
    func didSelectDone() {
//        guard case .sorting(let vc) = self.currentScreen else { return }
//        vc.viewModel = SortViewModel.generate(for: self.exerciseSettings.dificulty)
    }
}

extension NewAppFlowCoordinator: MenuViewControllerProtocol {
    func menuViewControllerDidSelectProceed(withSelectedOption option: Int) {
//        if case .dificulties(_) = self.currentScreen {
//            self.exerciseSettings.dificulty = ExerciseDificulty.allCases[option]
//            self.showMenuScreen()
//        } else if case .exerciseTypes(_) = self.currentScreen {
//            self.exerciseSettings.type = ExerciseType.allCases[option]
//            if case .sorting = self.exerciseSettings.type {
//                self.showSortScreen()
//            } else if case .computing = self.exerciseSettings.type {
//                self.showComputationsScreen()
//            }
//        }
    }
}


class TableVc : UITableViewController {
    
    override func viewDidLoad() {
        self.title = "Things"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "\(indexPath.row)";
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

