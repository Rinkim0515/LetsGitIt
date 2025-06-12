//
//  HomeCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {
    var onFinished: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHome()
    }
    
    private func showHome() {
        let homeVC = DIContainer.shared.makeHomeViewController()
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func showIssueDetail(_ issue: GitHubIssue) {
        let issueDetailCoordinator = IssueDetailCoordinator(
            navigationController: navigationController,
            issue: issue
        )
        issueDetailCoordinator.onFinished = { [weak self, weak issueDetailCoordinator] in
            guard let self = self, let coordinator = issueDetailCoordinator else { return }
            self.childCoordinators.removeAll { $0 === coordinator }
        }
        
        childCoordinators.append(issueDetailCoordinator)
        issueDetailCoordinator.start()
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        let milestoneDetailCoordinator = MilestoneDetailCoordinator(
            navigationController: navigationController,
            milestone: milestone
        )
        
        milestoneDetailCoordinator.onFinished = { [weak self, weak milestoneDetailCoordinator] in
            guard let self = self, let coordinator = milestoneDetailCoordinator else { return }
            self.childCoordinators.removeAll { $0 === coordinator }
        }
        
        childCoordinators.append(milestoneDetailCoordinator)
        milestoneDetailCoordinator.start()
    }
    
    func navigateBackToHome() {
        navigationController.popViewController(animated: true)
    }
    
    
}
