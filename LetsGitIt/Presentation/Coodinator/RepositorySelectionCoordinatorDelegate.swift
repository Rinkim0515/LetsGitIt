//
//  RepositorySelectionCoordinatorDelegate.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit
// MARK: - Repository Selection Coordinator
protocol RepositorySelectionCoordinatorDelegate: AnyObject {
    func repositorySelectionDidComplete()
}

final class RepositorySelectionCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: RepositorySelectionCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repositorySelectionVC = DIContainer.shared.makeRepositorySelectionViewController()
        repositorySelectionVC.coordinator = self
        navigationController.setViewControllers([repositorySelectionVC], animated: false)
    }
    
    func repositorySelectionDidComplete() {
        delegate?.repositorySelectionDidComplete()
    }
}
