//
//  AppCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var onFinished: (() -> Void)? { get set }
    func start()
}


protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}


final class AppCoordinator: Coordinator {
    var onFinished: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        
        if GitHubAuthManager.shared.isLoggedIn {
            if hasSelectedRepository() {
                startMainFlow()
            } else {
                startRepositorySelectionFlow()
            }
        } else {
            startAuthFlow()
        }
    }
    
    func authenticationDidComplete() {
        cleanupCurrentCoordinators()
        
        if hasSelectedRepository() {
            startMainFlow()
        } else {
            startRepositorySelectionFlow()
        }
    }
    private func cleanupCurrentCoordinators() {
        childCoordinators.forEach { coordinator in
            coordinator.onFinished?()
        }
        childCoordinators.removeAll()
    }
    

    
    private func startAuthFlow() {
        let loginVC = DIContainer.shared.makeLoginViewController()
        window.rootViewController = loginVC
        let authCoordinator = AuthCoordinator(loginViewController: loginVC)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func startRepositorySelectionFlow() {
        let repositorySelectionVC = DIContainer.shared.makeRepositorySelectionViewController()
        window.rootViewController = repositorySelectionVC
        let repoCoordinator = RepositorySelectionCoordinator(repositorySelectionViewController: repositorySelectionVC)
        repoCoordinator.delegate = self
        childCoordinators.append(repoCoordinator)
        repoCoordinator.start()
    }
    
    private func startMainFlow() {
        let tabBarController = DIContainer.shared.makeMainTabBarController()
        window.rootViewController = tabBarController
        let mainCoordinator = MainCoordinator(tabBarController: tabBarController)
        mainCoordinator.delegate = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    // MARK: - Private Methods
    private func hasSelectedRepository() -> Bool {
        let repoName = UserDefaults.standard.string(forKey: "selected_repository_name")
        let repoOwner = UserDefaults.standard.string(forKey: "selected_repository_owner")
        return repoName != nil && repoOwner != nil
    }
}


// MARK: - AppCoordinator Delegate Methods
extension AppCoordinator: AuthCoordinatorDelegate {
    func authDidComplete() {
        cleanupCurrentCoordinators()
        startRepositorySelectionFlow()
    }
}

extension AppCoordinator: RepositorySelectionCoordinatorDelegate {
    func repositorySelectionDidComplete() {
        cleanupCurrentCoordinators()
        startMainFlow()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    
    func mainDidRequestLogout() {
        GitHubAuthManager.shared.logout()
        cleanupCurrentCoordinators()
        startAuthFlow()
    }
    
    func mainDidRequestRepositoryChange() {
        print("🔄 AppCoordinator: 리포지토리 변경으로 인한 앱 재시작")
        cleanupCurrentCoordinators()
        startMainFlow() // 메인 플로우 재시작
    }
}
