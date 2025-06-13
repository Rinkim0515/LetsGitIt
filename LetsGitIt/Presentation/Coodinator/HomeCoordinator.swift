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
        let homeVC = DIContainer.shared.makeHomeVC()
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
        // ✅ 선택된 리포지토리 정보 가져오기
        guard let repository = getSelectedRepository() else {
            print("❌ 선택된 리포지토리 정보가 없습니다")
            return
        }
        
        // ✅ DIContainer 사용으로 변경
        let milestoneDetailCoordinator = DIContainer.shared.makeMilestoneDetailCoordinator(
            navigationController: navigationController,
            milestone: milestone,
            repository: repository
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
    
    // MARK: - Private Helper Methods
    private func getSelectedRepository() -> GitHubRepository? {
        // UserDefaults에서 선택된 리포지토리 정보 가져오기
        guard let repoName = UserDefaults.standard.string(forKey: "selected_repository_name"),
              let repoOwner = UserDefaults.standard.string(forKey: "selected_repository_owner") else {
            print("❌ UserDefaults에 리포지토리 정보가 없습니다")
            return nil
        }
        
        print("📍 선택된 리포지토리: \(repoOwner)/\(repoName)")
        
        // ✅ GitHubRepository 객체 생성 (HomeVC에서 사용하는 정보와 동일하게)
        return GitHubRepository(
            id: 0, // 임시 ID (실제로는 캐시에서 가져와야 함)
            name: repoName,
            fullName: "\(repoOwner)/\(repoName)",
            description: nil,
            language: nil,
            starCount: 0,
            forkCount: 0,
            isPrivate: false,
            owner: GitHubUser(
                id: 0,
                login: repoOwner,
                name: repoOwner,
                avatarURL: "",
                bio: nil,
                publicRepos: 0,
                followers: 0,
                following: 0
            ),
            updatedAt: Date()
        )
    }
}
