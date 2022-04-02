//
//  AppFlowCoordinator.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 21.02.2022.
//

import UIKit

enum AppScreen {
    case dificulties(MenuViewController) , exerciseTypes(MenuViewController), sorting(SortViewController), computing(UIViewController), none
    
    var viewController: UIViewController? {
        switch self {
        case .none : return nil
        case .dificulties(let vc): return vc
        case .exerciseTypes(let vc): return vc
        case .sorting(let vc): return vc
        case .computing(let vc): return vc
        }
    }
}

enum ExerciseDificulty: String, CaseIterable {
    case class0 = "Clasa 0"
    case class1 = "Clasa 1"
    
    static var allOptions: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

enum ExerciseType: String, CaseIterable {
    case sorting = "Sortare"
//    case computing = "Operatii"
    
    static var allOptions: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

class ExerciseSettings {
    var dificulty: ExerciseDificulty = .class0
    var type: ExerciseType = .sorting
}

class AppFlowCoordinator: NSObject {
    
    var currentScreen: AppScreen = .none
    var exerciseSettings = ExerciseSettings()
    
    func getInitialScreen() -> UIViewController {
        //let vc = self.getMenuScreen(for: .dificulties(self.getMenuViewController()))
        let vc = self.getSortScreen()
        self.currentScreen = .sorting(vc)//.dificulties(vc)
        return vc
    }
    
    func getMenuScreen(for screenType: AppScreen) -> MenuViewController {
        let vc = screenType.viewController as? MenuViewController ?? MenuViewController()

        if case .dificulties(_) = screenType {
            vc.options = ExerciseDificulty.allCases.map { $0.rawValue }
        } else {
            vc.options = ExerciseType.allCases.map { $0.rawValue }
        }
        
        vc.delegate = self
        
        return vc
    }
    
    func getMenuViewController() -> MenuViewController {
        let vc = MenuViewController.getFromMainStoryboard() ?? MenuViewController()
        vc.delegate = self
        return vc
    }
    
    
    func getSortScreen() -> SortViewController {
        let sortViewController = SortViewController.getFromMainStoryboard() ?? SortViewController()
        sortViewController.viewModel = SortViewModel.generate(for: self.exerciseSettings.dificulty)
        sortViewController.delegate = self
        return sortViewController
    }
    
    func showMenuScreen() {
        let vc = self.getMenuScreen(for: .exerciseTypes(self.getMenuViewController()))
        vc.modalPresentationStyle = .fullScreen

        self.currentScreen.viewController?.present(vc, animated:true, completion:nil)
        self.currentScreen = .exerciseTypes(vc)
    }
    
    func showSortScreen() {
        let sortViewController = self.getSortScreen()
        
        sortViewController.modalPresentationStyle = .fullScreen
        self.currentScreen.viewController?.present(sortViewController, animated:true, completion:nil)
        self.currentScreen = .sorting(sortViewController)
    }
    
    func show(screen: AppScreen) {
        if let vc = screen.viewController {
            vc.modalPresentationStyle = .fullScreen
            self.currentScreen.viewController?.present(vc, animated:true, completion:nil)
        }
        self.currentScreen = screen
    }
}


extension AppFlowCoordinator: MenuViewControllerProtocol {
    func menuViewControllerDidSelectProceed(withSelectedOption option: Int) {
        if case .dificulties(_) = self.currentScreen {
            self.exerciseSettings.dificulty = ExerciseDificulty.allCases[option]
            self.showMenuScreen()
        } else if case .exerciseTypes(_) = self.currentScreen {
            self.exerciseSettings.type = ExerciseType.allCases[option]
            if case .sorting = self.exerciseSettings.type {
                self.showSortScreen()
            }
        }
    }
}

extension AppFlowCoordinator: ExerciseViewControllerProtocol {
    func didSelectSettings() {
        let screen = AppScreen.dificulties(self.getMenuViewController())
        let vc = self.getMenuScreen(for: screen)
        vc.modalPresentationStyle = .fullScreen

        self.currentScreen.viewController?.present(vc, animated:true, completion:nil)
        self.currentScreen = screen
    }
}

extension UIViewController {
    static func getFromMainStoryboard() -> Self? {
        UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
    }
}
