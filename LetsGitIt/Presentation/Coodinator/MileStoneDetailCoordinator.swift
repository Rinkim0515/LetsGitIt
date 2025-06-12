//
//  MilestoneDetailCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/12/25.
//

import UIKit

final class MilestoneDetailCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    var onFinished: (() -> Void)?
    private let milestone: GitHubMilestone
    
    init(navigationController: UINavigationController, milestone: GitHubMilestone) {
        self.navigationController = navigationController
        self.milestone = milestone
    }
    
    func start() {
        print("🚀 MilestoneDetailCoordinator 시작: \(milestone.title)")
        let milestoneDetailVC = DIContainer.shared.makeMilestoneDetailViewController(milestone: milestone)
        milestoneDetailVC.coordinator = self
        milestoneDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(milestoneDetailVC, animated: true)
    }
    
    // MARK: - Flow Methods
    func navigateBack() {
        print("⬅️ 마일스톤 상세에서 뒤로가기")
        navigationController.popViewController(animated: true)
        onFinished?()  // 부모에게 완료 알림
    }
    
    func showIssueDetail(_ issue: GitHubIssue) {
        print("📝 마일스톤에서 이슈 상세로 이동: #\(issue.number)")
        
        let issueDetailCoordinator = IssueDetailCoordinator(
            navigationController: navigationController,
            issue: issue
        )
        
        // 완료 시 child에서 제거
        issueDetailCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === issueDetailCoordinator }
            print("✅ IssueDetailCoordinator 메모리 해제됨 (from Milestone)")
        }
        
        childCoordinators.append(issueDetailCoordinator)
        issueDetailCoordinator.start()
    }
    
    // 향후 확장 가능한 메서드들
    func refreshMilestone() {
        print("🔄 마일스톤 새로고침")
        // TODO: 필요시 구현
    }
    
    func shareMilestone() {
        print("🔗 마일스톤 공유")
        // TODO: 필요시 구현
    }
}
