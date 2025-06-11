//
//  MainCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 5/29/25.
//

import UIKit




// MARK: - Main Coordinator
protocol MainCoordinatorDelegate: AnyObject {
    func mainDidRequestLogout()
}

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainTabBarController = DIContainer.shared.makeMainTabBarController()
        setupTabBarCoordinators(mainTabBarController)
        navigationController.setViewControllers([mainTabBarController], animated: false)
    }
    
    private func setupTabBarCoordinators(_ tabBarController: MainTabBarController) {
        guard let viewControllers = tabBarController.viewControllers else { return }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let navController = viewController as? UINavigationController {
                switch index {
                case 0: // Home
                    let homeCoordinator = HomeCoordinator(navigationController: navController)
                    childCoordinators.append(homeCoordinator)
                    homeCoordinator.start() // ✅ 여기서 HomeVC 생성 및 설정
                    
                case 1: // Dashboard
                    // TODO: DashboardCoordinator 구현 시 추가
                    let dashboardVC = DIContainer.shared.makeDashboardVC()
                    navController.setViewControllers([dashboardVC], animated: false)
                    
                case 2: // Repository
                    // TODO: AllRepositoryCoordinator 구현 시 추가
                    let allRepositoryVC = DIContainer.shared.makeAllRepositoryVC()
                    navController.setViewControllers([allRepositoryVC], animated: false)
                    
                case 3: // Settings
                    // TODO: SettingsCoordinator 구현 시 추가
                    let settingVC = SettingViewController()
                    navController.setViewControllers([settingVC], animated: false)
                    
                default:
                    break
                }
            }
        }
    }
    
    func logout() {
        delegate?.mainDidRequestLogout()
    }
}

// MARK: - Settings Coordinator Delegate
extension MainCoordinator: SettingsCoordinatorDelegate {
    func settingsDidRequestLogout() {
        logout()
    }
}

// MARK: - Tab Coordinators


final class DashboardCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dashboardVC = DIContainer.shared.makeDashboardVC()
        navigationController.setViewControllers([dashboardVC], animated: false)
    }
}
