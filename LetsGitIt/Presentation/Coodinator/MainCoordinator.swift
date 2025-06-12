//
//  MainCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 5/29/25.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func mainDidRequestLogout()
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
        print("🚀 MainCoordinator 시작 - TabBar 설정")
        setupTabBarCoordinators()
    }
    
    // MARK: - TabBar 설정 (업계 표준)
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
    
    // MARK: - 각 Tab 설정 메서드들
    private func setupHomeTab(_ navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        
        homeCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === homeCoordinator }
            
        }
        
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    private func setupDashboardTab(_ navigationController: UINavigationController) {
        let dashboardCoordinator = DashboardCoordinator(navigationController: navigationController)
        
        // ✅ child coordinator 관리
        dashboardCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === dashboardCoordinator }
            
        }
        
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
    
    private func setupRepositoryTab(_ navigationController: UINavigationController) {
        let allRepositoryCoordinator = RepositoryListCoordinator(navigationController: navigationController)
        
        // ✅ child coordinator 관리
        allRepositoryCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === allRepositoryCoordinator }
            
        }
        
        childCoordinators.append(allRepositoryCoordinator)
        allRepositoryCoordinator.start()
    }
    
    private func setupSettingsTab(_ navigationController: UINavigationController) {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.delegate = self
        
        // ✅ child coordinator 관리
        settingsCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === settingsCoordinator }
            
        }
        
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    // MARK: - Public Methods
    func requestLogout() {
        // ✅ 모든 child coordinator 정리
        childCoordinators.removeAll()
        
        
        delegate?.mainDidRequestLogout()
        onFinished?()  // ✅ 완료 알림
    }
}

// MARK: - Settings Coordinator Delegate
extension MainCoordinator: SettingsCoordinatorDelegate {
    func settingsDidRequestLogout() {
        requestLogout()
    }
}








