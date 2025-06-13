//
//  DIContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit

final class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - 레이어별 컨테이너들 (내부 관리)
    private lazy var networkContainer = NetworkContainer()
    private lazy var repositoryContainer = RepositoryContainer(networkContainer: networkContainer)
    private lazy var useCaseContainer = UseCaseContainer(repositoryContainer: repositoryContainer)
    private lazy var vcContainer = VCContainer(useCaseContainer: useCaseContainer)
    
    private init() {}
    

    func makeLoginVC() -> LoginVC {
        return LoginVC()
    }
    func makeReposSelectionVC() -> ReposSelectionVC {
        return vcContainer.makeRepoSelectionVC()
    }
    func makeMainTabBarController() -> MainTabBarController {
        return vcContainer.makeMainTabBarController()
    }
    func makeHomeVC() -> HomeVC {
        return HomeVC(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getMilestonesUseCase: useCaseContainer.getRepositoryMilestonesUseCase,
            getIssuesUseCase: useCaseContainer.getRepositoryIssuesUseCase
        )
    }
    
    func makeIssueDetailVC(issue: GitHubIssue) -> IssueDetailVC {
        return IssueDetailVC(issue: issue)
    }
    
    func makeMilestoneDetailVC(milestone: GitHubMilestone, repository: GitHubRepository) -> MilestoneDetailVC {
        return MilestoneDetailVC(
            milestone: milestone,
            repository: repository,
            getMilestoneDetailUseCase: useCaseContainer.getMilestoneDetailUseCase
        )
    }
    
    func makeDashboardVC() -> DashboardVC {
        return vcContainer.makeDashboardVC()
    }
    
    // MARK: - Repository Tab ViewControllers
    func makeRepoListVC() -> RepoListVC {
        return vcContainer.makeAllRepositoryVC()
    }
    
    func makeRepoDetailVC(repository: GitHubRepository) -> RepoDetailVC {
        return RepoDetailVC(
            repository: repository,
            getMilestonesUseCase: useCaseContainer.getRepositoryMilestonesUseCase,
            getIssuesUseCase: useCaseContainer.getRepositoryIssuesUseCase
        )
    }
    
    // MARK: - Settings Tab ViewControllers
    func makeSettingsVC() -> SettingVC {
        return SettingVC()
    }
    
    func makeCoreTimeSettingsVC() -> CoreTimeSettingVC {
        let currentTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        return CoreTimeSettingVC(title: "코어타임 설정", initialTime: currentTime)
    }
    
    func makeNotiSettingsVC() -> NotiSettingVC {
        return NotiSettingVC(selectedOption: .none)
    }
    
    func makeWeekdaySettingVC() -> WeekdaySettingVC {
        return WeekdaySettingVC(selectedDays: [])
    }
    
    
}



// MARK: - Coordinator Factory Methods (새로 추가)
extension DIContainer {
    
    // ✅ IssueDetailCoordinator 생성
    func makeIssueDetailCoordinator(
        navigationController: UINavigationController,
        issue: GitHubIssue
    ) -> IssueDetailCoordinator {
        return IssueDetailCoordinator(navigationController: navigationController, issue: issue)
    }
    
    // ✅ MilestoneDetailCoordinator 생성
    
    // ✅ RepositoryDetailCoordinator 생성
    func makeRepositoryDetailCoordinator(
        navigationController: UINavigationController,
        repository: GitHubRepository
    ) -> RepositoryDetailCoordinator {
        return RepositoryDetailCoordinator(navigationController: navigationController, repository: repository)
    }
    
    func makeMilestoneDetailCoordinator(
        navigationController: UINavigationController,
        milestone: GitHubMilestone,
        repository: GitHubRepository
    ) -> MilestoneDetailCoordinator {
        return MilestoneDetailCoordinator(
            navigationController: navigationController,
            milestone: milestone,
            repository: repository
        )
    }
}
