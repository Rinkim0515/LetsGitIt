//
//  MainCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 5/29/25.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func mainDidRequestLogout()
    func mainDidRequestRepositoryChange() 
}

final class MainCoordinator: Coordinator {
    var onFinished: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?
    
    private let tabBarController: MainTabBarController
    
    init(tabBarController: MainTabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        setupTabBarCoordinators()
    }
    
    private func setupTabBarCoordinators() {
        guard let viewControllers = tabBarController.viewControllers else { return }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let navController = viewController as? UINavigationController {
                switch index {
                case 0: // Home Tab
                    setupHomeTab(navController)
                case 1: // Dashboard Tab
                    setupDashboardTab(navController)
                case 2: // Repository Tab
                    setupRepositoryTab(navController)
                case 3: // Settings Tab
                    setupSettingsTab(navController)
                default:
                    break
                }
            }
        }
    }
    
    private func setupHomeTab(_ navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        setupCoordinatorCleanup(homeCoordinator)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    private func setupDashboardTab(_ navigationController: UINavigationController) {
        let dashboardCoordinator = DashboardCoordinator(navigationController: navigationController)
        setupCoordinatorCleanup(dashboardCoordinator)
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
    
    private func setupRepositoryTab(_ navigationController: UINavigationController) {
        let repositoryCoordinator = RepositoryListCoordinator(navigationController: navigationController)
        setupCoordinatorCleanup(repositoryCoordinator)
        childCoordinators.append(repositoryCoordinator)
        repositoryCoordinator.start()
    }
    
    private func setupSettingsTab(_ navigationController: UINavigationController) {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.delegate = self
        setupCoordinatorCleanup(settingsCoordinator)
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    private func setupCoordinatorCleanup<T: Coordinator>(_ coordinator: T) {
        coordinator.onFinished = { [weak self] in
            self?.removeChildCoordinator(coordinator)
        }
    }
    
    private func removeChildCoordinator<T: Coordinator>(_ coordinator: T) {
        childCoordinators.removeAll { $0 === coordinator }
        print("✅ \(String(describing: type(of: coordinator))) 메모리 해제됨")
    }
    
    func requestLogout() {
        childCoordinators.removeAll()
        delegate?.mainDidRequestLogout()
        onFinished?()
    }
}

// MARK: - Settings Coordinator Delegate
extension MainCoordinator: SettingsCoordinatorDelegate {
    func settingsDidRequestLogout() {
        requestLogout()
    }
    func settingsDidChangeRepository() {
        print("🔄 MainCoordinator: 리포지토리 변경됨")
        
        delegate?.mainDidRequestRepositoryChange()
    }
}









