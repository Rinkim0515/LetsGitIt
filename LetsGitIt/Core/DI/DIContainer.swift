//
//  DIContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit


final class DIContainer {
    
    // MARK: - Shared Instance
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Data Layer
    private lazy var gitHubAPIService: GitHubAPIService = {
        return GitHubAPIService()
    }()
    
    private lazy var gitHubUserRepository: GitHubUserRepositoryProtocol = {
        return GitHubUserRepository(apiService: gitHubAPIService)
    }()
    
    private lazy var gitHubRepositoryRepository: GitHubRepositoryRepositoryProtocol = {
        return GitHubRepositoryRepository(apiService: gitHubAPIService)
    }()
    
    // MARK: - Domain Layer (UseCases)
    private lazy var getCurrentUserUseCase: GetCurrentUserUseCase = {
        return GetCurrentUserUseCase(userRepository: gitHubUserRepository)
    }()
    
    private lazy var getUserRepositoriesUseCase: GetUserRepositoriesUseCase = {
        return GetUserRepositoriesUseCase(repositoryRepository: gitHubRepositoryRepository)
    }()
    
    
    // MARK: - Presentation Layer Factory Methods
    func makeHomeVC() -> HomeViewController {
        return HomeViewController(getCurrentUserUseCase: getCurrentUserUseCase)
    }
    
    func makeDashboardVC() -> DashboardViewController {
        return DashboardViewController()
    }
    func makeRepositorySelectionViewController() -> RepositorySelectionViewController {
        return RepositorySelectionViewController(
            getCurrentUserUseCase: getCurrentUserUseCase,
            getUserRepositoriesUseCase: getUserRepositoriesUseCase
        )
    }
    
    func makeAllRepositoryVC() -> AllRepositoryViewController {
        return AllRepositoryViewController(
            getCurrentUserUseCase: getCurrentUserUseCase,
            getUserRepositoriesUseCase: getUserRepositoriesUseCase
        )
    }
    
    
    func makeMainTabBarController() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        
        // 프로필 탭
        let homeVC = makeHomeVC()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // 레포지토리 탭
        let dashBoardVC = makeDashboardVC()
        dashBoardVC.tabBarItem = UITabBarItem(
            title: "대시보드",
            image: UIImage(systemName: "folder"),
            selectedImage: UIImage(systemName: "folder.fill")
        )
        
        let allRepositoryVC = makeAllRepositoryVC()
        allRepositoryVC.tabBarItem = UITabBarItem(
            title: "레포지토리",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = UITabBarItem(
            title: "세팅",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        
        // 네비게이션 컨트롤러로 감싸기
        let homeNav = UINavigationController(rootViewController: homeVC)
        let dashBoardNav = UINavigationController(rootViewController: dashBoardVC)
        let allRepositoryNav = UINavigationController(rootViewController: allRepositoryVC)
        let settingNav = UINavigationController(rootViewController: settingVC)
        
        tabBarController.viewControllers = [homeNav, dashBoardNav, allRepositoryNav, settingNav]
        
        return tabBarController
    }
}
