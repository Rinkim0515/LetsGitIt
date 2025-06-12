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
        issueDetailCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === issueDetailCoordinator }
            print("✅ IssueDetailCoordinator 메모리 해제됨")
        }
        
        childCoordinators.append(issueDetailCoordinator)
        issueDetailCoordinator.start()
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        let milestoneDetailCoordinator = MilestoneDetailCoordinator(
            navigationController: navigationController,
            milestone: milestone
        )
        milestoneDetailCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === milestoneDetailCoordinator }
            print("✅ MilestoneDetailCoordinator 메모리 해제됨")
        }
        
        childCoordinators.append(milestoneDetailCoordinator)
        milestoneDetailCoordinator.start()
    }
    
    func navigateBackToHome() {
        navigationController.popViewController(animated: true)
    }
    
    
}
