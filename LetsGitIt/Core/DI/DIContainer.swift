//
//  DIContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit


final class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - 레이어별 컨테이너들 (내부 관리)
    private lazy var networkContainer = NetworkContainer()
    private lazy var repositoryContainer = RepositoryContainer(networkContainer: networkContainer)
    private lazy var useCaseContainer = UseCaseContainer(repositoryContainer: repositoryContainer)
    private lazy var viewControllerContainer = ViewControllerContainer(useCaseContainer: useCaseContainer)
    
    private init() {}
    
    
    func makeHomeVC() -> HomeViewController {
        return viewControllerContainer.makeHomeVC()
    }
    
    func makeDashboardVC() -> DashboardViewController {
        return viewControllerContainer.makeDashboardVC()
    }
    
    func makeRepositorySelectionViewController() -> RepositorySelectionViewController {
        return viewControllerContainer.makeRepositorySelectionViewController()
    }
    
    func makeAllRepositoryVC() -> AllRepositoryViewController {
        return viewControllerContainer.makeAllRepositoryVC()
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        return viewControllerContainer.makeMainTabBarController()
    }
}
