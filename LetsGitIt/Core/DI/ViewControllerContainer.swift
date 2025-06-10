//
//  as.swift
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
    
    func makeAllRepositoryVC() -> AllRepositoryViewController {
        print("📱 AllRepositoryViewController 생성됨")
        return AllRepositoryViewController(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getUserRepositoriesUseCase: useCaseContainer.getUserRepositoriesUseCase
        )
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        print("📱 MainTabBarController 생성됨")
        let tabBarController = MainTabBarController()
        
        // 탭별 ViewController 생성
        let homeVC = makeHomeVC()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
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
