//
//  AllRepositoryCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class AllRepositoryCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("🚀 AllRepositoryCoordinator 시작")
        showAllRepositories()
    }
    
    // MARK: - Navigation Flow Methods
    private func showAllRepositories() {
        let allRepositoryVC = DIContainer.shared.makeAllRepositoryViewController()
        allRepositoryVC.coordinator = self
        navigationController.setViewControllers([allRepositoryVC], animated: false)
        print("📱 AllRepositoryViewController 설정 완료")
    }
    
    // MARK: - Flow Methods (AllRepositoryViewController에서 호출)
    func showRepositoryDetail(_ repository: GitHubRepository) {
        print("📁 리포지토리 상세 화면: \(repository.name)")
        let repositoryDetailVC = DIContainer.shared.makeRepositoryDetailViewController(repository: repository)
        repositoryDetailVC.coordinator = self
        navigationController.pushViewController(repositoryDetailVC, animated: true)
    }
    
    func showIssuesList(_ repository: GitHubRepository) {
        print("📋 이슈 목록 화면: \(repository.name)")
        // RepositoryDetailViewController 내부의 세그먼트에서 처리
        // 별도 화면이 필요하면 구현
    }
    
    func showMilestonesList(_ repository: GitHubRepository) {
        print("🎯 마일스톤 목록 화면: \(repository.name)")
        // RepositoryDetailViewController 내부의 세그먼트에서 처리
    }
    
    func showIssueDetailFromRepository(_ issue: GitHubIssue) {
        print("📝 리포지토리에서 이슈 상세: #\(issue.number)")
        let issueDetailVC = DIContainer.shared.makeIssueDetailViewController(issue: issue)
        issueDetailVC.onBackTapped = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(issueDetailVC, animated: true)
    }
    
    func showMilestoneDetailFromRepository(_ milestone: GitHubMilestone) {
        print("🎯 리포지토리에서 마일스톤 상세: \(milestone.title)")
        let milestoneDetailVC = DIContainer.shared.makeMilestoneDetailViewController(milestone: milestone)
        milestoneDetailVC.onBackTapped = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(milestoneDetailVC, animated: true)
    }
    
    func navigateBackToRepositoryList() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissRepositoryDetail() {
        print("📱 리포지토리 상세 닫기")
        navigationController.popViewController(animated: true)
    }
}
