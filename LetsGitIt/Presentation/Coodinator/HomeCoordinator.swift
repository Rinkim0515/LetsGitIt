//
//  HomeCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = DIContainer.shared.makeHomeVC()
        
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func showIssueDetail(_ issue: GitHubIssue) {
        let issueDetailVC = IssueDetailViewController(issue: issue)
        issueDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(issueDetailVC, animated: true)
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        // TODO: 마일스톤 상세 화면 구현 시 추가
        print("📍 마일스톤 상세로 이동: \(milestone.title)")
    }
}
