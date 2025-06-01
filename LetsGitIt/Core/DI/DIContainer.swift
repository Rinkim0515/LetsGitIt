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
    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController(getCurrentUserUseCase: getCurrentUserUseCase)
    }
    
    func makeRepositoryListViewController() -> RepositoryListViewController {
        return RepositoryListViewController(getUserRepositoriesUseCase: getUserRepositoriesUseCase)
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        
        // 프로필 탭
        let profileVC = makeProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "프로필",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        // 레포지토리 탭
        let repoVC = makeRepositoryListViewController()
        repoVC.tabBarItem = UITabBarItem(
            title: "레포지토리",
            image: UIImage(systemName: "folder"),
            selectedImage: UIImage(systemName: "folder.fill")
        )
        
        // 네비게이션 컨트롤러로 감싸기
        let profileNav = UINavigationController(rootViewController: profileVC)
        let repoNav = UINavigationController(rootViewController: repoVC)
        
        tabBarController.viewControllers = [profileNav, repoNav]
        
        return tabBarController
    }
}
