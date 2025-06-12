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
        print("🎯 AppCoordinator: 인증 완료 처리")
        childCoordinators.removeAll()
        startRepositorySelectionFlow()
    }
    
    // MARK: - Private Methods
    
    private func startAuthFlow() {
        print("🔐 인증 Flow 시작")
        
        // Auth는 단일 화면이므로 NavigationController 불필요
        let loginVC = DIContainer.shared.makeLoginViewController()
        window.rootViewController = loginVC
        
        let authCoordinator = AuthCoordinator(loginViewController: loginVC)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func startRepositorySelectionFlow() {
        print("📁 리포지토리 선택 Flow 시작")
        
        // Repository Selection도 단일 화면
        let repositorySelectionVC = DIContainer.shared.makeRepositorySelectionViewController()
        window.rootViewController = repositorySelectionVC
        
        let repoCoordinator = RepositorySelectionCoordinator(repositorySelectionViewController: repositorySelectionVC)
        repoCoordinator.delegate = self
        childCoordinators.append(repoCoordinator)
        repoCoordinator.start()
    }
    
    private func startMainFlow() {
        print("🏠 메인 Flow 시작 - TabBar + Navigation")
        
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
