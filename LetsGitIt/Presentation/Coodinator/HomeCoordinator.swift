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
        print("🚀 HomeCoordinator 시작")
        showHome()
    }
    
    // MARK: - Navigation Flow Methods
    private func showHome() {
        // ✅ 업계 표준: DIContainer로 생성 후 coordinator 주입
        let homeVC = DIContainer.shared.makeHomeViewController()
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: false)
        print("📱 HomeViewController 설정 완료")
    }
    
    // MARK: - Flow Methods (HomeViewController에서 호출)
    func showIssueDetail(_ issue: GitHubIssue) {
        print("📍 이슈 상세 화면으로 이동: #\(issue.number)")
        let issueDetailVC = DIContainer.shared.makeIssueDetailViewController(issue: issue)
        issueDetailVC.coordinator = self
        navigationController.pushViewController(issueDetailVC, animated: true)
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        print("📍 마일스톤 상세 화면으로 이동: \(milestone.title)")
        let milestoneDetailVC = DIContainer.shared.makeMilestoneDetailViewController(milestone: milestone)
        milestoneDetailVC.coordinator = self
        navigationController.pushViewController(milestoneDetailVC, animated: true)
    }
    
    func navigateBackToHome() {
        print("🏠 홈으로 돌아가기")
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismissDetail() {
        print("📱 상세 화면 닫기")
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Additional Flow Methods
    func showUserProfile(_ user: GitHubUser) {
        print("👤 사용자 프로필 표시: \(user.login)")
        // 필요시 사용자 프로필 화면 구현
    }
    
    func showCreateIssue() {
        print("➕ 새 이슈 생성 화면")
        // 필요시 이슈 생성 화면 구현
    }
}
