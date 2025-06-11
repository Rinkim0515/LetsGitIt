//
//  AppCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}


final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // 로그인 상태 확인 후 적절한 flow 시작
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
    
    // MARK: - Private Methods
    private func hasSelectedRepository() -> Bool {
        let repoName = UserDefaults.standard.string(forKey: "selected_repository_name")
        let repoOwner = UserDefaults.standard.string(forKey: "selected_repository_owner")
        return repoName != nil && repoOwner != nil
    }
    
    private func startAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func startRepositorySelectionFlow() {
        let repoCoordinator = RepositorySelectionCoordinator(navigationController: navigationController)
        repoCoordinator.delegate = self
        childCoordinators.append(repoCoordinator)
        repoCoordinator.start()
    }
    
    private func startMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.delegate = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}

// MARK: - AppCoordinator Delegate Methods
extension AppCoordinator: AuthCoordinatorDelegate {
    func authDidComplete() {
        // 인증 완료 후 레포지토리 선택으로 이동
        childCoordinators.removeAll()
        startRepositorySelectionFlow()
    }
}

extension AppCoordinator: RepositorySelectionCoordinatorDelegate {
    func repositorySelectionDidComplete() {
        // 레포지토리 선택 완료 후 메인 화면으로 이동
        childCoordinators.removeAll()
        startMainFlow()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainDidRequestLogout() {
        // 로그아웃 후 로그인 화면으로 이동
        GitHubAuthManager.shared.logout()
        childCoordinators.removeAll()
        startAuthFlow()
    }
}
