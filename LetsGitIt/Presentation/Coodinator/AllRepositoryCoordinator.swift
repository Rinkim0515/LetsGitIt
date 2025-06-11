//
//  AllRepositoryCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class AllRepositoryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let allRepositoryVC = DIContainer.shared.makeAllRepositoryVC()
        allRepositoryVC.coordinator = self
        navigationController.setViewControllers([allRepositoryVC], animated: false)
    }
    
    func showRepositoryDetail(_ repository: GitHubRepository) {
        let repositoryDetailVC = RepositoryDetailViewController(repository: repository)
        repositoryDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(repositoryDetailVC, animated: true)
    }
}
