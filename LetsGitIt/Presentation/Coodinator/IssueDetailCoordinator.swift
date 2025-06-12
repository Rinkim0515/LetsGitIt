//
//  IssueDetailCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/12/25.
//

import UIKit

final class IssueDetailCoordinator: NavigationCoordinator {
    var onFinished: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let issue: GitHubIssue
    
    init (navigationController: UINavigationController, issue: GitHubIssue) {
        self.navigationController = navigationController
        self.issue = issue
        
    }
    
    func start() {
        let issueDetailVC = DIContainer.shared.makeIssueDetailVC(issue: issue)
        issueDetailVC.coordinator = self
        issueDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(issueDetailVC, animated: true)
    }
    
    func navigateBack() {
        print("⬅️ 이슈 상세에서 뒤로가기")
        navigationController.popViewController(animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.onFinished?() // 순환참조 문제
        }
    }
    
    deinit {
        print("🗑️ IssueDetailCoordinator deinit 호출됨")
    }
}

