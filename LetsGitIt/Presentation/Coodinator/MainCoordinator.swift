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
        // ✅ MainCoordinator가 직접 TabBar 생성 및 설정
        let mainTabBarController = createMainTabBarController()
        setupTabBarCoordinators(mainTabBarController)
        navigationController.setViewControllers([mainTabBarController], animated: false)
    }
    
    // MARK: - TabBar 생성 (✅ DIContainer 역할을 MainCoordinator가 대신)
    private func createMainTabBarController() -> MainTabBarController {
        print("📱 MainTabBarController 생성됨")
        let tabBarController = MainTabBarController()
        
        // ✅ 빈 NavigationController들 생성 (각 Coordinator가 내용 채움)
        let homeNav = createTabNavigationController(
            title: "홈",
            systemImageName: "house"
        )
        
        let dashboardNav = createTabNavigationController(
            title: "대시보드",
            systemImageName: "folder"
        )
        
        let repositoryNav = createTabNavigationController(
            title: "레포지토리",
            systemImageName: "doc.text"
        )
        
        let settingsNav = createTabNavigationController(
            title: "세팅",
            systemImageName: "gearshape"
        )
        
        tabBarController.viewControllers = [homeNav, dashboardNav, repositoryNav, settingsNav]
        
        return tabBarController
    }
    
    // MARK: - Helper: NavigationController 생성
    private func createTabNavigationController(title: String, systemImageName: String) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: systemImageName),
            selectedImage: UIImage(systemName: systemImageName + ".fill")
        )
        return navController
    }
    
    // MARK: - 각 탭에 Coordinator 설정
    private func setupTabBarCoordinators(_ tabBarController: MainTabBarController) {
        guard let viewControllers = tabBarController.viewControllers else { return }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let navController = viewController as? UINavigationController {
                switch index {
                case 0: // Home
                    let homeCoordinator = HomeCoordinator(navigationController: navController)
                    childCoordinators.append(homeCoordinator)
                    homeCoordinator.start()
                    
                case 1: // Dashboard
                    let dashboardCoordinator = DashboardCoordinator(navigationController: navController)
                    childCoordinators.append(dashboardCoordinator)
                    dashboardCoordinator.start()
                    
                case 2: // Repository
                    let repositoryCoordinator = AllRepositoryCoordinator(navigationController: navController)
                    childCoordinators.append(repositoryCoordinator)
                    repositoryCoordinator.start()
                    
                case 3: // Settings
                    let settingsCoordinator = SettingsCoordinator(navigationController: navController)
                    settingsCoordinator.delegate = self
                    childCoordinators.append(settingsCoordinator)
                    settingsCoordinator.start()
                    
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
