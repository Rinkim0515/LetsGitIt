//
//  HomeCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {
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
        let issueDetailCoordinator = IssueDetailCoordinator(navigationController: navigationController, issue)
        
        issueDetailCoordinator.start()
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        print("📍 마일스톤 상세 화면으로 이동: \(milestone.title)")
        let milestoneDetailVC = DIContainer.shared.makeMilestoneDetailViewController(milestone: milestone)
        milestoneDetailVC.onBackTapped = { [weak self] in
            self?.navigateBackToHome()
        }
        milestoneDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(milestoneDetailVC, animated: true)
    }
    
    func navigateBackToHome() {
        navigationController.popViewController(animated: true)
    }
    
    
}
