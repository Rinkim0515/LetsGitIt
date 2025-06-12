//
//  ViewControllerContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class ViewControllerContainer {
    private let useCaseContainer: UseCaseContainer
    
    init(useCaseContainer: UseCaseContainer) {
        self.useCaseContainer = useCaseContainer
    }
    
    // MARK: - ViewController 생성 (coordinator는 나중에 주입)
    func makeHomeVC() -> HomeViewController {
        print("📱 HomeViewController 생성됨")
        return HomeViewController(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getMilestonesUseCase: useCaseContainer.getRepositoryMilestonesUseCase,
            getIssuesUseCase: useCaseContainer.getRepositoryIssuesUseCase
        )
    }
    
    func makeDashboardVC() -> DashboardViewController {
        print("📱 DashboardViewController 생성됨")
        return DashboardViewController()
    }
    
    func makeRepositorySelectionViewController() -> RepositorySelectionViewController {
        print("📱 RepositorySelectionViewController 생성됨")
        return RepositorySelectionViewController(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getUserRepositoriesUseCase: useCaseContainer.getUserRepositoriesUseCase
        )
    }
    
    func makeAllRepositoryVC() -> RepositroyListViewController {
        print("📱 AllRepositoryViewController 생성됨")
        return RepositroyListViewController(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getUserRepositoriesUseCase: useCaseContainer.getUserRepositoriesUseCase
        )
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        print("📱 MainTabBarController 생성됨")
        let tabBarController = MainTabBarController()
        
        let homeNav = UINavigationController()
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let dashBoardNav = UINavigationController()
        dashBoardNav.tabBarItem = UITabBarItem(
            title: "대시보드",
            image: UIImage(systemName: "folder"),
            selectedImage: UIImage(systemName: "folder.fill")
        )
        
        let allRepositoryNav = UINavigationController()
        allRepositoryNav.tabBarItem = UITabBarItem(
            title: "레포지토리",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        let settingNav = UINavigationController()
        settingNav.tabBarItem = UITabBarItem(
            title: "세팅",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        tabBarController.viewControllers = [homeNav, dashBoardNav, allRepositoryNav, settingNav]
        
        return tabBarController
    }
}
