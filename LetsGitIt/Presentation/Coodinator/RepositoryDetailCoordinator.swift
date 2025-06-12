//
//  RepositoryDetailCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/12/25.
//

import UIKit

final class RepositoryDetailCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    var onFinished: (() -> Void)?
    private let repository: GitHubRepository
    
    init(navigationController: UINavigationController, repository: GitHubRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        print("🚀 RepositoryDetailCoordinator 시작: \(repository.name)")
        let repositoryDetailVC = DIContainer.shared.makeRepoDetailVC(repository: repository)
        repositoryDetailVC.coordinator = self
        repositoryDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(repositoryDetailVC, animated: true)
    }
    
    // MARK: - Flow Methods
    func navigateBack() {
        print("⬅️ 리포지토리 상세에서 뒤로가기")
        navigationController.popViewController(animated: true)
        onFinished?()  // 부모에게 완료 알림
    }
    
    func showIssueDetail(_ issue: GitHubIssue) {
        print("📝 리포지토리에서 이슈 상세로 이동: #\(issue.number)")
        
        let issueDetailCoordinator = IssueDetailCoordinator(
            navigationController: navigationController,
            issue: issue
        )
        
        
        issueDetailCoordinator.onFinished = { [weak self, weak issueDetailCoordinator] in
            guard let self = self, let coordinator = issueDetailCoordinator else { return }
            self.childCoordinators.removeAll { $0 === coordinator }
            print("✅ \(type(of: coordinator)) 메모리 해제됨")
        }
        
        childCoordinators.append(issueDetailCoordinator)
        issueDetailCoordinator.start()
    }
    
    func showMilestoneDetail(_ milestone: GitHubMilestone) {
        print("🎯 리포지토리에서 마일스톤 상세로 이동: \(milestone.title)")
        
        let milestoneDetailCoordinator = MilestoneDetailCoordinator(
            navigationController: navigationController,
            milestone: milestone
        )
        
        // 완료 시 child에서 제거
        milestoneDetailCoordinator.onFinished = { [weak self, weak milestoneDetailCoordinator] in
            guard let self = self, let coordinator = milestoneDetailCoordinator else { return }
            self.childCoordinators.removeAll { $0 === coordinator }
        }
        
        childCoordinators.append(milestoneDetailCoordinator)
        milestoneDetailCoordinator.start()
    }
    
    // 향후 확장 가능한 메서드들
    func shareRepository() {
        print("🔗 리포지토리 공유")
        // TODO: 필요시 구현
    }
    
    func showRepositorySettings() {
        print("⚙️ 리포지토리 설정")
        // TODO: 필요시 구현
    }
}
