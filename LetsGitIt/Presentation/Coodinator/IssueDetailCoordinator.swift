//
//  IssueDetailCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/12/25.
//

import UIKit

final class IssueDetailCoordinator: NavigationCoordinator {

    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let issue: GitHubIssue
    
    init (navigationController: UINavigationController, _ issue: GitHubIssue) {
        self.navigationController = navigationController
        self.issue = issue
        
    }
    
    func start() {
        let issueDetailVC = DIContainer.shared.makeIssueDetailViewController(issue: issue)
        issueDetailVC.coordinator = self
        
    }
    
}

